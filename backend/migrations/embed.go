package migrations

import "embed"

// Files berisi seluruh skema database yang dijalankan oleh golang-migrate.
//
//go:embed *.sql
var Files embed.FS
