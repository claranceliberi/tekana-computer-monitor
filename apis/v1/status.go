package v1

import (
	"github.com/gin-gonic/gin"
)

func GetStatus(c *gin.Context) {
	c.JSON(200, gin.H{
		"status": "running",
	})
}
