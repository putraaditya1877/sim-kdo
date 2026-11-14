package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"sim-kdo/backend/internal/httpx"
)

type healthResponse struct {
	API string `json:"api"`
	DB  string `json:"db"`
}

func Health(db *gorm.DB) gin.HandlerFunc {
	return func(c *gin.Context) {
		sqlDB, err := db.DB()
		if err != nil || sqlDB.PingContext(c.Request.Context()) != nil {
			httpx.Failure(c, http.StatusServiceUnavailable, "Database tidak tersedia", map[string]any{"db": "down"})
			return
		}
		httpx.Success(c, http.StatusOK, "API dan database sehat", healthResponse{API: "up", DB: "up"})
	}
}
