package main

import (
	"log"
	"os"

	"sim-kdo/backend/internal/config"
	"sim-kdo/backend/internal/database"
	"sim-kdo/backend/internal/router"
	"sim-kdo/backend/internal/seed"
)

func main() {
	command := "serve"
	if len(os.Args) > 1 {
		command = os.Args[1]
	}
	cfg := config.Load()
	db, err := database.Open(cfg.DatabaseURL)
	if err != nil {
		log.Fatal(err)
	}

	switch command {
	case "migrate":
		if len(os.Args) < 3 {
			log.Fatal("gunakan: migrate up|down")
		}
		if err := database.Migrate(db, os.Args[2]); err != nil {
			log.Fatal(err)
		}
		return
	case "seed":
		if err := database.Migrate(db, "up"); err != nil {
			log.Fatal(err)
		}
		if err := seed.Run(db); err != nil {
			log.Fatal(err)
		}
		return
	case "serve":
		if cfg.MigrateOnStart {
			if err := database.Migrate(db, "up"); err != nil {
				log.Fatal(err)
			}
		}
	default:
		log.Fatalf("perintah tidak dikenal: %s", command)
	}

	if err := router.New(db, cfg).Run(cfg.HTTPAddr); err != nil {
		log.Fatal(err)
	}
}
