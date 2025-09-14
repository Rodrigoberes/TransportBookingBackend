package routes

import (
	"database/sql"

	"github.com/Rodrigoberes/TransportBookingBackend/internal/api/handlers"
	"github.com/Rodrigoberes/TransportBookingBackend/internal/api/middleware"
	"github.com/gin-gonic/gin"
)

func SetupRoutes(router *gin.Engine, db *sql.DB) {
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
			auth.POST("/login", func(c *gin.Context) { handlers.Login(c, db) })
		}

		// Protected routes
		protected := v1.Group("/")
		protected.Use(middleware.AuthRequired())
		{
			// User routes
			protected.GET("/users/:id", func(c *gin.Context) { handlers.GetUser(c, db) })
			protected.PUT("/users/:id", func(c *gin.Context) { handlers.UpdateUser(c, db) })

			// Route routes
			protected.GET("/routes", func(c *gin.Context) { handlers.GetRoutes(c, db) })
			protected.POST("/routes", func(c *gin.Context) { handlers.CreateRoute(c, db) })

			// Booking routes
			protected.GET("/bookings", func(c *gin.Context) { handlers.GetBookings(c, db) })
			protected.POST("/bookings", func(c *gin.Context) { handlers.CreateBooking(c, db) })
		}
	}
}