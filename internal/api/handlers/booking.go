package handlers

import (
	"database/sql"
	"net/http"
	"strconv"
	"time"

	"github.com/Rodrigoberes/TransportBookingBackend/internal/models"
	"github.com/Rodrigoberes/TransportBookingBackend/internal/repository"
	"github.com/gin-gonic/gin"
)

// CreateBookingRequest represents the booking creation request with seat selection
type CreateBookingRequest struct {
	ScheduleID        int      `json:"schedule_id" binding:"required"`
	TravelDate        string   `json:"travel_date" binding:"required"`
	PassengerName     string   `json:"passenger_name" binding:"required"`
	PassengerDocument string   `json:"passenger_document" binding:"required"`
	PassengerPhone    string   `json:"passenger_phone" binding:"required"`
	SeatIDs           []int    `json:"seat_ids" binding:"required,min=1"`
	PaymentMethod     string   `json:"payment_method"`
	Notes             string   `json:"notes"`
}

// CreateBooking godoc
// @Summary Create a new booking with seat selection
// @Description Create a new booking with seat selection and simulated payment
// @Tags bookings
// @Accept json
// @Produce json
// @Param booking body CreateBookingRequest true "Booking data with seat selection"
// @Success 201 {object} models.Booking
// @Failure 400 {object} map[string]string
// @Failure 409 {object} map[string]string
// @Router /bookings [post]
func CreateBooking(c *gin.Context, db *sql.DB) {
	// Get user ID from context
	userIDInterface, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not authenticated"})
		return
	}
	userID, ok := userIDInterface.(int)
	if !ok {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Invalid user ID"})
		return
	}

	var req CreateBookingRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Parse travel date
	travelDate, err := time.Parse("2006-01-02", req.TravelDate)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid travel date format. Use YYYY-MM-DD"})
		return
	}

	// Check if seats are available for the selected schedule and date
	availableSeats, err := repository.GetAvailableSeatsForSchedule(db, req.ScheduleID, req.TravelDate)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to check seat availability"})
		return
	}

	// Create a map of available seat IDs for quick lookup
	availableSeatMap := make(map[int]bool)
	for _, seat := range availableSeats {
		availableSeatMap[seat.ID] = true
	}

	// Check if all requested seats are available
	for _, seatID := range req.SeatIDs {
		if !availableSeatMap[seatID] {
			c.JSON(http.StatusConflict, gin.H{"error": "One or more selected seats are not available"})
			return
		}
	}

	// Get schedule details to calculate departure datetime
	schedule, err := repository.GetScheduleByID(db, req.ScheduleID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get schedule details"})
		return
	}

	// Get route details to get the base price
	route, err := repository.GetRouteByID(db, schedule.RouteID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to get route details"})
		return
	}

	// Calculate departure datetime by combining travel date with schedule departure time
	departureTime, err := time.Parse("15:04:05", schedule.DepartureTime)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Invalid schedule departure time"})
		return
	}

	departureDateTime := time.Date(
		travelDate.Year(), travelDate.Month(), travelDate.Day(),
		departureTime.Hour(), departureTime.Minute(), departureTime.Second(),
		0, time.UTC,
	)

	// Calculate total amount (base price * number of seats)
	// In a real app, you'd calculate this based on seat types and modifiers
	totalAmount := route.BasePrice * float64(len(req.SeatIDs))

	// Create booking
	booking := models.Booking{
		UserID:            userID,
		ScheduleID:        req.ScheduleID,
		TravelDate:        travelDate,
		DepartureDatetime: departureDateTime,
		PassengerName:     req.PassengerName,
		PassengerDocument: req.PassengerDocument,
		PassengerPhone:    req.PassengerPhone,
		TotalAmount:       totalAmount,
		PaymentStatus:     "paid", // Simulate payment success
		BookingStatus:     "confirmed",
		PaymentMethod:     req.PaymentMethod,
		Notes:             req.Notes,
	}

	// Generate booking code
	booking.BookingCode = "BK" + strconv.Itoa(userID) + strconv.FormatInt(time.Now().Unix(), 10)

	// Start transaction
	tx, err := db.Begin()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to start transaction"})
		return
	}
	defer tx.Rollback()

	// Create booking
	if err := repository.CreateBooking(tx, &booking); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create booking"})
		return
	}

	// Assign seats to booking
	for _, seatID := range req.SeatIDs {
		bookingSeat := models.BookingSeat{
			BookingID: booking.ID,
			SeatID:    seatID,
		}

		if err := repository.CreateBookingSeat(tx, &bookingSeat); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to assign seat"})
			return
		}

		// Mark seat as unavailable
		if err := repository.UpdateSeatAvailability(tx, seatID, false); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update seat availability"})
			return
		}
	}

	// Commit transaction
	if err := tx.Commit(); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to commit transaction"})
		return
	}

	c.JSON(http.StatusCreated, booking)
}

// GetBookings godoc
// @Summary Get bookings for user
// @Description Get list of bookings for the authenticated user
// @Tags bookings
// @Accept json
// @Produce json
// @Success 200 {array} models.Booking
// @Router /bookings [get]
func GetBookings(c *gin.Context, db *sql.DB) {
	// Get user ID from context (set by auth middleware)
	userIDInterface, exists := c.Get("user_id")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "User not authenticated"})
		return
	}
	userID, ok := userIDInterface.(int)
	if !ok {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Invalid user ID"})
		return
	}

	bookings, err := repository.GetBookingsByUserID(db, userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, bookings)
}

// GetBooking godoc
// @Summary Get booking by ID
// @Description Get booking information by ID
// @Tags bookings
// @Accept json
// @Produce json
// @Param id path int true "Booking ID"
// @Success 200 {object} models.Booking
// @Failure 404 {object} map[string]string
// @Router /bookings/{id} [get]
func GetBooking(c *gin.Context, db *sql.DB) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid booking ID"})
		return
	}

	booking, err := repository.GetBookingByID(db, id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Booking not found"})
		return
	}

	c.JSON(http.StatusOK, booking)
}

// UpdateBooking godoc
// @Summary Update booking
// @Description Update booking information
// @Tags bookings
// @Accept json
// @Produce json
// @Param id path int true "Booking ID"
// @Param booking body models.Booking true "Booking data"
// @Success 200 {object} models.Booking
// @Failure 400 {object} map[string]string
// @Router /bookings/{id} [put]
func UpdateBooking(c *gin.Context, db *sql.DB) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid booking ID"})
		return
	}

	var booking models.Booking
	if err := c.ShouldBindJSON(&booking); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	booking.ID = id

	if err := repository.UpdateBooking(db, &booking); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, booking)
}

// DeleteBooking godoc
// @Summary Delete booking
// @Description Delete a booking by ID
// @Tags bookings
// @Accept json
// @Produce json
// @Param id path int true "Booking ID"
// @Success 204
// @Failure 500 {object} map[string]string
// @Router /bookings/{id} [delete]
func DeleteBooking(c *gin.Context, db *sql.DB) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid booking ID"})
		return
	}

	if err := repository.DeleteBooking(db, id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}