package models

import "time"

type Seat struct {
	ID             int     `json:"id" db:"id"`
	VehicleID      int     `json:"vehicle_id" db:"vehicle_id"`
	SeatNumber     string  `json:"seat_number" db:"seat_number"`
	SeatType       string  `json:"seat_type" db:"seat_type"`
	RowNumber      int     `json:"row_number" db:"row_number"`
	ColumnPosition string  `json:"column_position" db:"column_position"`
	PriceModifier  float64 `json:"price_modifier" db:"price_modifier"`
	IsAvailable    bool    `json:"is_available" db:"is_available"`
	CreatedAt      time.Time `json:"created_at" db:"created_at"`
}