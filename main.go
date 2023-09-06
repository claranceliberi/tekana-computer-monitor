package main

import (
	v1 "github.com/claranceliberi/tekana-computer-monitor/apis/v1"
	middleware "github.com/claranceliberi/tekana-computer-monitor/middleware"
	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()

	// Use our custom logger middleware
	router.Use(middleware.LoggerMiddleware())

	// API Version 1 routes
	v1Group := router.Group("/v1")
	{
		v1Group.GET("/status", v1.GetStatus)
		v1Group.GET("/sysinfo", v1.GetSystemInfo)
		// Add other v1 routes here
	}

	// Run the server on port 8080
	router.Run(":8080")
}
