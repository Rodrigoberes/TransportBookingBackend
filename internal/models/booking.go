package models

import "time"

type Booking struct {
	ID                int       `json:"id" db:"id"`
	UserID            int       `json:"user_id" db:"user_id"`
	ScheduleID        int       `json:"schedule_id" db:"schedule_id"`
	BookingCode       string    `json:"booking_code" db:"booking_code"`
	TravelDate        time.Time `json:"travel_date" db:"travel_date"`
	DepartureDatetime time.Time `json:"departure_datetime" db:"departure_datetime"`
	PassengerName     string    `json:"passenger_name" db:"passenger_name"`
	PassengerDocument string    `json:"passenger_document" db:"passenger_document"`
	PassengerPhone    string    `json:"passenger_phone" db:"passenger_phone"`
	TotalAmount       float64   `json:"total_amount" db:"total_amount"`
	PaymentStatus     string    `json:"payment_status" db:"payment_status"`
	BookingStatus     string    `json:"booking_status" db:"booking_status"`
	PaymentMethod     string    `json:"payment_method" db:"payment_method"`
	Notes             string    `json:"notes" db:"notes"`
	CreatedAt         time.Time `json:"created_at" db:"created_at"`
	UpdatedAt         time.Time `json:"updated_at" db:"updated_at"`
}