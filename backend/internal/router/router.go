package router

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"sim-kdo/backend/internal/config"
	"sim-kdo/backend/internal/handler"
	"sim-kdo/backend/internal/middleware"
)

func New(db *gorm.DB, cfg config.Config) *gin.Engine {
	r := gin.New()
	r.Use(gin.Logger(), gin.Recovery(), middleware.CORS(cfg.CORSOrigins))

	v1 := r.Group("/api/v1")
	v1.GET("/health", handler.Health(db))
	return r
}
