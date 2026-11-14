package router

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"sim-kdo/backend/internal/config"
	"sim-kdo/backend/internal/handler"
	"sim-kdo/backend/internal/middleware"
	"sim-kdo/backend/internal/repository"
	"sim-kdo/backend/internal/service"
)

func New(db *gorm.DB, cfg config.Config) *gin.Engine {
	r := gin.New()
	r.Use(gin.Logger(), gin.Recovery(), middleware.CORS(cfg.CORSOrigins))

	v1 := r.Group("/api/v1")
	v1.GET("/health", handler.Health(db))

	api := handler.NewAPI(service.New(repository.New(db), cfg.JWTSecret))
	v1.POST("/auth/login", api.Login)
	protected := v1.Group("/")
	protected.Use(middleware.Auth(cfg.JWTSecret))
	protected.GET("/auth/me", api.Me)
	protected.GET("/golongan", api.Golongan)
	protected.GET("/dashboard", api.Dashboard)

	protected.GET("/perangkat-daerah/trash", api.TrashPD)
	protected.GET("/perangkat-daerah", api.ListPD)
	protected.POST("/perangkat-daerah", api.SavePD)
	protected.GET("/perangkat-daerah/:id", api.GetPD)
	protected.PUT("/perangkat-daerah/:id", api.UpdatePD)
	protected.DELETE("/perangkat-daerah/:id", api.DeletePD)
	protected.PATCH("/perangkat-daerah/:id/restore", api.RestorePD)
	protected.DELETE("/perangkat-daerah/:id/force", middleware.RequireRole("admin"), api.ForcePD)

	protected.GET("/pegawai/trash", api.TrashPegawai)
	protected.GET("/pegawai", api.ListPegawai)
	protected.POST("/pegawai", api.SavePegawai)
	protected.GET("/pegawai/:id", api.GetPegawai)
	protected.PUT("/pegawai/:id", api.UpdatePegawai)
	protected.DELETE("/pegawai/:id", api.DeletePegawai)
	protected.PATCH("/pegawai/:id/restore", api.RestorePegawai)
	protected.DELETE("/pegawai/:id/force", middleware.RequireRole("admin"), api.ForcePegawai)

	protected.GET("/kendaraan/trash", api.TrashKendaraan)
	protected.GET("/kendaraan", api.ListKendaraan)
	protected.POST("/kendaraan", api.SaveKendaraan)
	protected.GET("/kendaraan/:id", api.GetKendaraan)
	protected.PUT("/kendaraan/:id", api.UpdateKendaraan)
	protected.DELETE("/kendaraan/:id", api.DeleteKendaraan)
	protected.PATCH("/kendaraan/:id/restore", api.RestoreKendaraan)
	protected.DELETE("/kendaraan/:id/force", middleware.RequireRole("admin"), api.ForceKendaraan)

	protected.GET("/penugasan", api.ListPenugasan)
	protected.POST("/penugasan", api.SavePenugasan)
	protected.PATCH("/penugasan/:id/selesai", api.FinishPenugasan)
	protected.DELETE("/penugasan/:id", api.DeletePenugasan)
	return r
}
