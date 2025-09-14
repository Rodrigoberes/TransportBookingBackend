package models

import "time"

type Vehicle struct {
	ID          int             `json:"id" db:"id"`
	CompanyID   int             `json:"company_id" db:"company_id"`
	LicensePlate string         `json:"license_plate" db:"license_plate"`
	VehicleType string          `json:"vehicle_type" db:"vehicle_type"`
	Brand       string          `json:"brand" db:"brand"`
	Model       string          `json:"model" db:"model"`
	Year        int             `json:"year" db:"year"`
	TotalSeats  int             `json:"total_seats" db:"total_seats"`
	SeatLayout  interface{}     `json:"seat_layout" db:"seat_layout"`
	Amenities   interface{}     `json:"amenities" db:"amenities"`
	IsActive    bool            `json:"is_active" db:"is_active"`
	CreatedAt   time.Time       `json:"created_at" db:"created_at"`
	UpdatedAt   time.Time       `json:"updated_at" db:"updated_at"`
}