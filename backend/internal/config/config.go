package config

import (
	"os"
	"strconv"
)

type Config struct {
	HTTPAddr       string
	DatabaseURL    string
	CORSOrigins    string
	MigrateOnStart bool
}

func Load() Config {
	return Config{
		HTTPAddr:       env("HTTP_ADDR", ":8080"),
		DatabaseURL:    env("DATABASE_URL", "postgres://simkdo:simkdo@localhost:5432/sim_kdo?sslmode=disable"),
		CORSOrigins:    env("CORS_ORIGINS", "http://localhost:3000"),
		MigrateOnStart: boolEnv("MIGRATE_ON_START", false),
	}
}

func boolEnv(key string, fallback bool) bool {
	value, err := strconv.ParseBool(os.Getenv(key))
	if err != nil {
		return fallback
	}
	return value
}

func env(key, fallback string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return fallback
}
