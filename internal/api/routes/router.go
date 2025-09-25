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

		// Public travel search (no auth required)
		v1.GET("/travels/search", func(c *gin.Context) { handlers.SearchAvailableTravels(c, db) })
		v1.GET("/travels/seats", func(c *gin.Context) { handlers.GetAvailableSeatsForSchedule(c, db) })

		// Protected routes
		protected := v1.Group("/")
		protected.Use(middleware.AuthRequired(cfg.JWTSecret))
		{
			// User routes
			protected.POST("/users", func(c *gin.Context) { handlers.CreateUser(c, db) })
			protected.GET("/users", func(c *gin.Context) { handlers.GetAllUsers(c, db) })
			protected.GET("/users/search", func(c *gin.Context) { handlers.SearchUsers(c, db) })
			protected.GET("/users/:id", func(c *gin.Context) { handlers.GetUser(c, db) })
			protected.PUT("/users/:id", func(c *gin.Context) { handlers.UpdateUser(c, db) })
			protected.DELETE("/users/:id", func(c *gin.Context) { handlers.DeleteUser(c, db) })

			// Company routes
			protected.GET("/companies", func(c *gin.Context) { handlers.GetAllCompanies(c, db) })
			protected.POST("/companies", func(c *gin.Context) { handlers.CreateCompany(c, db) })
			protected.GET("/companies/:id", func(c *gin.Context) { handlers.GetCompany(c, db) })
			protected.PUT("/companies/:id", func(c *gin.Context) { handlers.UpdateCompany(c, db) })
			protected.DELETE("/companies/:id", func(c *gin.Context) { handlers.DeleteCompany(c, db) })

			// Route routes
			protected.GET("/routes", func(c *gin.Context) { handlers.GetAllRoutes(c, db) })
			protected.POST("/routes", func(c *gin.Context) { handlers.CreateRoute(c, db) })
			protected.GET("/routes/:id", func(c *gin.Context) { handlers.GetRoute(c, db) })
			protected.PUT("/routes/:id", func(c *gin.Context) { handlers.UpdateRoute(c, db) })
			protected.DELETE("/routes/:id", func(c *gin.Context) { handlers.DeleteRoute(c, db) })

			// Booking routes
			protected.GET("/bookings", func(c *gin.Context) { handlers.GetBookings(c, db) })
			protected.POST("/bookings", func(c *gin.Context) { handlers.CreateBooking(c, db) })
			protected.GET("/bookings/:id", func(c *gin.Context) { handlers.GetBooking(c, db) })
			protected.PUT("/bookings/:id", func(c *gin.Context) { handlers.UpdateBooking(c, db) })
			protected.DELETE("/bookings/:id", func(c *gin.Context) { handlers.DeleteBooking(c, db) })
		}
	}
}