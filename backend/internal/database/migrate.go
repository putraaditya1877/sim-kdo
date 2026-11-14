package database

import (
	"database/sql"

	"github.com/golang-migrate/migrate/v4"
	_ "github.com/golang-migrate/migrate/v4/database/postgres"
	"github.com/golang-migrate/migrate/v4/source/iofs"
	"gorm.io/gorm"
	"sim-kdo/backend/migrations"
)

func Migrate(db *gorm.DB, direction string) error {
	sqlDB, err := db.DB()
	if err != nil {
		return err
	}
	if err := sqlDB.Ping(); err != nil {
		return err
	}
	return migrateWithSQL(sqlDB, direction)
}

func migrateWithSQL(sqlDB *sql.DB, direction string) error {
	source, err := iofs.New(migrations.Files, ".")
	if err != nil {
		return err
	}
	driver, err := postgresDriver(sqlDB)
	if err != nil {
		return err
	}
	m, err := migrate.NewWithInstance("iofs", source, "postgres", driver)
	if err != nil {
		return err
	}

	switch direction {
	case "up":
		err = m.Up()
	case "down":
		err = m.Steps(-1)
	default:
		return &invalidDirection{direction}
	}
	if err == migrate.ErrNoChange {
		return nil
	}
	return err
}
