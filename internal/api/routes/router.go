package routes

import (
	"database/sql"

	"github.com/Rodrigoberes/TransportBookingBackend/internal/api/handlers"
	"github.com/Rodrigoberes/TransportBookingBackend/internal/api/middleware"
	"github.com/Rodrigoberes/TransportBookingBackend/internal/config"
	"github.com/gin-gonic/gin"
)

func SetupRoutes(router *gin.Engine, db *sql.DB, cfg *config.Config) {
	// Middleware
	router.Use(middleware.CORS())
	router.Use(middleware.Logger())

	// Health check
	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{"status": "ok"})
	})

	// API v1 group
	v1 := router.Group("/api/v1")
	{
		// Auth routes
		auth := v1.Group("/auth")
		{
			auth.POST("/register", func(c *gin.Context) { handlers.Register(c, db) })
			auth.POST("/login", func(c *gin.Context) { handlers.Login(c, db, cfg.JWTSecret) })
		}

		// All routes public (no auth required)
		v1.GET("/travels/search", func(c *gin.Context) { handlers.SearchAvailableTravels(c, db) })
		v1.GET("/travels/seats", func(c *gin.Context) { handlers.GetAvailableSeatsForSchedule(c, db) })
		v1.GET("/companies", func(c *gin.Context) { handlers.GetAllCompanies(c, db) })
		v1.POST("/companies", func(c *gin.Context) { handlers.CreateCompany(c, db) })
		v1.GET("/companies/:id", func(c *gin.Context) { handlers.GetCompany(c, db) })
		v1.PUT("/companies/:id", func(c *gin.Context) { handlers.UpdateCompany(c, db) })
		v1.DELETE("/companies/:id", func(c *gin.Context) { handlers.DeleteCompany(c, db) })

		// Route routes
		v1.GET("/routes", func(c *gin.Context) { handlers.GetAllRoutes(c, db) })
		v1.POST("/routes", func(c *gin.Context) { handlers.CreateRoute(c, db) })
		v1.GET("/routes/:id", func(c *gin.Context) { handlers.GetRoute(c, db) })
		v1.PUT("/routes/:id", func(c *gin.Context) { handlers.UpdateRoute(c, db) })
		v1.DELETE("/routes/:id", func(c *gin.Context) { handlers.DeleteRoute(c, db) })

		// User routes
		v1.POST("/users", func(c *gin.Context) { handlers.CreateUser(c, db) })
		v1.GET("/users", func(c *gin.Context) { handlers.GetAllUsers(c, db) })
		v1.GET("/users/search", func(c *gin.Context) { handlers.SearchUsers(c, db) })
		v1.GET("/users/:id", func(c *gin.Context) { handlers.GetUser(c, db) })
		v1.PUT("/users/:id", func(c *gin.Context) { handlers.UpdateUser(c, db) })
		v1.DELETE("/users/:id", func(c *gin.Context) { handlers.DeleteUser(c, db) })

		// Booking routes
		v1.GET("/bookings", func(c *gin.Context) { handlers.GetBookings(c, db) })
		v1.POST("/bookings", func(c *gin.Context) { handlers.CreateBooking(c, db) })
		v1.GET("/bookings/:id", func(c *gin.Context) { handlers.GetBooking(c, db) })
		v1.PUT("/bookings/:id", func(c *gin.Context) { handlers.UpdateBooking(c, db) })
		v1.DELETE("/bookings/:id", func(c *gin.Context) { handlers.DeleteBooking(c, db) })
	}
}