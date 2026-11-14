package httpx

import "github.com/gin-gonic/gin"

type Envelope struct {
	Success bool           `json:"success"`
	Message string         `json:"message"`
	Data    any            `json:"data,omitempty"`
	Meta    any            `json:"meta,omitempty"`
	Errors  map[string]any `json:"errors,omitempty"`
}

func Success(c *gin.Context, status int, message string, data any) {
	c.JSON(status, Envelope{Success: true, Message: message, Data: data})
}

func Failure(c *gin.Context, status int, message string, errors map[string]any) {
	c.JSON(status, Envelope{Success: false, Message: message, Errors: errors})
}
