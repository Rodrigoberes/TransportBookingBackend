package handlers

import (
	"database/sql"
	"net/http"
	"strconv"

	"github.com/Rodrigoberes/TransportBookingBackend/internal/models"
	"github.com/Rodrigoberes/TransportBookingBackend/internal/repository"
	"github.com/gin-gonic/gin"
)

// CreateRoute godoc
// @Summary Create a new route
// @Description Create a new route
// @Tags routes
// @Accept json
// @Produce json
// @Param route body models.Route true "Route data"
// @Success 201 {object} models.Route
// @Failure 400 {object} map[string]string
// @Router /routes [post]
func CreateRoute(c *gin.Context, db *sql.DB) {
	var route models.Route
	if err := c.ShouldBindJSON(&route); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := repository.CreateRoute(db, &route); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, route)
}

// GetRoute godoc
// @Summary Get route by ID
// @Description Get route information by ID
// @Tags routes
// @Accept json
// @Produce json
// @Param id path int true "Route ID"
// @Success 200 {object} models.Route
// @Failure 404 {object} map[string]string
// @Router /routes/{id} [get]
func GetRoute(c *gin.Context, db *sql.DB) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid route ID"})
		return
	}

	route, err := repository.GetRouteByID(db, id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Route not found"})
		return
	}

	c.JSON(http.StatusOK, route)
}

// GetAllRoutes godoc
// @Summary Get all routes
// @Description Get list of all routes
// @Tags routes
// @Accept json
// @Produce json
// @Success 200 {array} models.Route
// @Router /routes [get]
func GetAllRoutes(c *gin.Context, db *sql.DB) {
	routes, err := repository.GetAllRoutes(db)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, routes)
}

// SearchAvailableTravels godoc
// @Summary Search available bus travels
// @Description Search for available bus travels by origin, destination, and date
// @Tags travels
// @Accept json
// @Produce json
// @Param origin query string false "Origin city"
// @Param destination query string false "Destination city"
// @Param date query string false "Travel date (YYYY-MM-DD)"
// @Success 200 {array} object
// @Router /api/v1/travels/search [get]
func SearchAvailableTravels(c *gin.Context, db *sql.DB) {
	origin := c.Query("origin")
	destination := c.Query("destination")
	date := c.Query("date")

	// Build query to get routes with schedules - including ALL relationship IDs
	query := `
		SELECT r.id, r.company_id, r.origin_city, r.origin_terminal, r.destination_city, r.destination_terminal,
			   r.distance_km, r.estimated_duration_minutes, r.base_price,
			   s.id as schedule_id, s.vehicle_id, s.departure_time, s.arrival_time, s.days_of_week,
			   c.id as company_id_full, c.name as company_name, c.email as company_email,
			   v.id as vehicle_id, v.license_plate, v.vehicle_type, v.brand, v.model, v.total_seats, v.amenities
		FROM routes r
		JOIN schedules s ON r.id = s.route_id
		JOIN companies c ON r.company_id = c.id
		JOIN vehicles v ON s.vehicle_id = v.id
		WHERE r.is_active = true AND s.is_active = true AND c.is_active = true AND v.is_active = true
	`

	args := []interface{}{}
	argCount := 0

	if origin != "" {
		argCount++
		query += " AND r.origin_city ILIKE $" + strconv.Itoa(argCount)
		args = append(args, "%"+origin+"%")
	}

	if destination != "" {
		argCount++
		query += " AND r.destination_city ILIKE $" + strconv.Itoa(argCount)
		args = append(args, "%"+destination+"%")
	}

	if date != "" {
		// For simplicity, we'll just return all matching routes
		// In a real app, you'd check the specific date against the schedule
	}

	query += " ORDER BY r.origin_city, r.destination_city, s.departure_time"

	rows, err := db.Query(query, args...)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	defer rows.Close()

	type TravelResult struct {
		// Route Information
		RouteID                  int     `json:"route_id"`
		CompanyID                int     `json:"company_id"` // Links route to company
		OriginCity               string  `json:"origin_city"`
		OriginTerminal           string  `json:"origin_terminal"`
		DestinationCity          string  `json:"destination_city"`
		DestinationTerminal      string  `json:"destination_terminal"`
		DistanceKm               int     `json:"distance_km"`
		EstimatedDurationMinutes int     `json:"estimated_duration_minutes"`
		BasePrice                float64 `json:"base_price"`

		// Schedule Information (links to route and vehicle)
		ScheduleID               int     `json:"schedule_id"`
		VehicleID                int     `json:"vehicle_id"` // Links schedule to vehicle
		DepartureTime            string  `json:"departure_time"`
		ArrivalTime              string  `json:"arrival_time"`
		DaysOfWeek               []int   `json:"days_of_week"`

		// Company Information
		CompanyIDFull            int     `json:"company_id_full"`
		CompanyName              string  `json:"company_name"`
		CompanyEmail             string  `json:"company_email"`

		// Vehicle Information (belongs to company, used by schedule)
		VehicleIDFull            int     `json:"vehicle_id_full"`
		LicensePlate             string  `json:"license_plate"`
		VehicleType              string  `json:"vehicle_type"`
		Brand                    string  `json:"brand"`
		Model                    string  `json:"model"`
		TotalSeats               int     `json:"total_seats"`
		Amenities                string  `json:"amenities"`
	}

	var results []TravelResult
	for rows.Next() {
		var result TravelResult
		err := rows.Scan(
			&result.RouteID, &result.CompanyID, &result.OriginCity, &result.OriginTerminal,
			&result.DestinationCity, &result.DestinationTerminal, &result.DistanceKm,
			&result.EstimatedDurationMinutes, &result.BasePrice, &result.ScheduleID,
			&result.VehicleID, &result.DepartureTime, &result.ArrivalTime, &result.DaysOfWeek,
			&result.CompanyIDFull, &result.CompanyName, &result.CompanyEmail,
			&result.VehicleIDFull, &result.LicensePlate, &result.VehicleType, &result.Brand,
			&result.Model, &result.TotalSeats, &result.Amenities,
		)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		results = append(results, result)
	}

	c.JSON(http.StatusOK, results)
}

// GetAvailableSeatsForSchedule godoc
// @Summary Get available seats for a specific schedule and date
// @Description Get list of available seats for booking
// @Tags travels
// @Accept json
// @Produce json
// @Param schedule_id query int true "Schedule ID"
// @Param travel_date query string true "Travel date (YYYY-MM-DD)"
// @Success 200 {array} models.Seat
// @Router /travels/seats [get]
func GetAvailableSeatsForSchedule(c *gin.Context, db *sql.DB) {
	scheduleIDStr := c.Query("schedule_id")
	travelDate := c.Query("travel_date")

	if scheduleIDStr == "" || travelDate == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "schedule_id and travel_date are required"})
		return
	}

	scheduleID, err := strconv.Atoi(scheduleIDStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid schedule_id"})
		return
	}

	seats, err := repository.GetAvailableSeatsForSchedule(db, scheduleID, travelDate)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, seats)
}

// UpdateRoute godoc
// @Summary Update route
// @Description Update route information
// @Tags routes
// @Accept json
// @Produce json
// @Param id path int true "Route ID"
// @Param route body models.Route true "Route data"
// @Success 200 {object} models.Route
// @Failure 400 {object} map[string]string
// @Router /routes/{id} [put]
func UpdateRoute(c *gin.Context, db *sql.DB) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid route ID"})
		return
	}

	var route models.Route
	if err := c.ShouldBindJSON(&route); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	route.ID = id

	if err := repository.UpdateRoute(db, &route); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, route)
}

// DeleteRoute godoc
// @Summary Delete route
// @Description Delete a route by ID
// @Tags routes
// @Accept json
// @Produce json
// @Param id path int true "Route ID"
// @Success 204
// @Failure 500 {object} map[string]string
// @Router /routes/{id} [delete]
func DeleteRoute(c *gin.Context, db *sql.DB) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid route ID"})
		return
	}

	if err := repository.DeleteRoute(db, id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}