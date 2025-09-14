package models

import "time"

type Schedule struct {
	ID                int       `json:"id" db:"id"`
	RouteID           int       `json:"route_id" db:"route_id"`
	VehicleID         int       `json:"vehicle_id" db:"vehicle_id"`
	DepartureTime     string    `json:"departure_time" db:"departure_time"`
	ArrivalTime       string    `json:"arrival_time" db:"arrival_time"`
	DaysOfWeek        []int     `json:"days_of_week" db:"days_of_week"`
	ValidFrom         time.Time `json:"valid_from" db:"valid_from"`
	ValidUntil        *time.Time `json:"valid_until" db:"valid_until"`
	IsActive          bool      `json:"is_active" db:"is_active"`
	CreatedAt         time.Time `json:"created_at" db:"created_at"`
	UpdatedAt         time.Time `json:"updated_at" db:"updated_at"`
}