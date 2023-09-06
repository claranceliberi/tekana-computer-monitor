package v1

import (
	utils "github.com/claranceliberi/tekana-computer-monitor/utilities"
	"github.com/gin-gonic/gin"
)

func GetSystemInfo(c *gin.Context) {
	details, err := utils.GetSystemDetails()
	if err != nil {
		c.JSON(500, gin.H{
			"error": err.Error(),
		})
		return
	}

	c.JSON(200, details)
}
