package database

import (
	"database/sql"

	migratedatabase "github.com/golang-migrate/migrate/v4/database"
	migratepostgres "github.com/golang-migrate/migrate/v4/database/postgres"
)

func postgresDriver(sqlDB *sql.DB) (migratedatabase.Driver, error) {
	return migratepostgres.WithInstance(sqlDB, &migratepostgres.Config{})
}

type invalidDirection struct{ value string }

func (e *invalidDirection) Error() string { return "arah migrasi tidak valid: " + e.value }
