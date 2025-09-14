package handlers

import (
	"database/sql"
	"net/http"
	"strconv"

	"github.com/Rodrigoberes/TransportBookingBackend/internal/models"
	"github.com/Rodrigoberes/TransportBookingBackend/internal/repository"
	"github.com/gin-gonic/gin"
)

// CreateBooking godoc
// @Summary Create a new booking
// @Description Create a new booking
// @Tags bookings
// @Accept json
// @Produce json
// @Param booking body models.Booking true "Booking data"
// @Success 201 {object} models.Booking
// @Failure 400 {object} map[string]string
// @Router /bookings [post]
func CreateBooking(c *gin.Context, db *sql.DB) {
	var booking models.Booking
	if err := c.ShouldBindJSON(&booking); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := repository.CreateBooking(db, &booking); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
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
	// Assuming user ID from context (set by auth middleware)
	userID := 1 // Placeholder, should get from JWT

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