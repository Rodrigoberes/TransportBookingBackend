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