package models

import "time"

type Route struct {
	ID                        int     `json:"id" db:"id"`
	CompanyID                 int     `json:"company_id" db:"company_id"`
	OriginCity                string  `json:"origin_city" db:"origin_city"`
	OriginTerminal            string  `json:"origin_terminal" db:"origin_terminal"`
	DestinationCity           string  `json:"destination_city" db:"destination_city"`
	DestinationTerminal       string  `json:"destination_terminal" db:"destination_terminal"`
	DistanceKm                int     `json:"distance_km" db:"distance_km"`
	EstimatedDurationMinutes  int     `json:"estimated_duration_minutes" db:"estimated_duration_minutes"`
	BasePrice                 float64 `json:"base_price" db:"base_price"`
	IsActive                  bool    `json:"is_active" db:"is_active"`
	CreatedAt                 time.Time `json:"created_at" db:"created_at"`
	UpdatedAt                 time.Time `json:"updated_at" db:"updated_at"`
}