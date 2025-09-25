package main

import (
	"log"
	"os"

	_ "github.com/Rodrigoberes/TransportBookingBackend/docs"
	"github.com/Rodrigoberes/TransportBookingBackend/internal/api/routes"
	"github.com/Rodrigoberes/TransportBookingBackend/internal/config"
	"github.com/Rodrigoberes/TransportBookingBackend/pkg/database"
	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

// @title Transport Booking API
// @version 1.0
// @description API for transport booking system
// @host localhost:8080
// @BasePath /api/v1
func main() {
	// Load configuration
	cfg := config.Load()

	// Initialize database
	db := database.Connect(cfg.DatabaseURL)
	defer db.Close()

	// Set Gin mode
	if cfg.Environment == "production" {
		gin.SetMode(gin.ReleaseMode)
	}

	// Initialize router
	router := gin.Default()

	// Setup routes
	routes.SetupRoutes(router, db, cfg)

	// Swagger endpoint
	router.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	// Start server
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("Server starting on port %s", port)
	if err := router.Run(":" + port); err != nil {
		log.Fatal("Failed to start server:", err)
	}
}