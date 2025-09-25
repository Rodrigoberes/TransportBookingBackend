package models

import "time"

type BookingSeat struct {
	ID        int       `json:"id" db:"id"`
	BookingID int       `json:"booking_id" db:"booking_id"`
	SeatID    int       `json:"seat_id" db:"seat_id"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
}