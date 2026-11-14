package repository

import (
	"context"

	"gorm.io/gorm"
)

type Repository struct{ DB *gorm.DB }

func New(db *gorm.DB) *Repository { return &Repository{DB: db} }

func (r *Repository) Query(ctx context.Context) *gorm.DB { return r.DB.WithContext(ctx) }
