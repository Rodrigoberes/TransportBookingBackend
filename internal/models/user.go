package models

import "time"

type User struct {
	ID             int       `json:"id" db:"id"`
	Email          string    `json:"email" db:"email"`
	Password       string    `json:"-" db:"password_hash"`
	FirstName      string    `json:"first_name" db:"first_name"`
	LastName       string    `json:"last_name" db:"last_name"`
	Phone          string    `json:"phone" db:"phone"`
	DocumentType   string    `json:"document_type" db:"document_type"`
	DocumentNumber string    `json:"document_number" db:"document_number"`
	IsActive       bool      `json:"is_active" db:"is_active"`
	CreatedAt      time.Time `json:"created_at" db:"created_at"`
	UpdatedAt      time.Time `json:"updated_at" db:"updated_at"`
}

type Company struct {
	ID        int       `json:"id" db:"id"`
	Name      string    `json:"name" db:"name"`
	Cuit      string    `json:"cuit" db:"cuit"`
	Phone     string    `json:"phone" db:"phone"`
	Email     string    `json:"email" db:"email"`
	Address   string    `json:"address" db:"address"`
	Icon      string    `json:"icon" db:"icon"`
	IsActive  bool      `json:"is_active" db:"is_active"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}