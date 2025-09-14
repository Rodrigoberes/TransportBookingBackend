package models

import "time"

type Payment struct {
	ID             int       `json:"id" db:"id"`
	BookingID      int       `json:"booking_id" db:"booking_id"`
	Amount         float64   `json:"amount" db:"amount"`
	PaymentMethod  string    `json:"payment_method" db:"payment_method"`
	PaymentStatus  string    `json:"payment_status" db:"payment_status"`
	TransactionID  string    `json:"transaction_id" db:"transaction_id"`
	PaymentGateway string    `json:"payment_gateway" db:"payment_gateway"`
	PaidAt         *time.Time `json:"paid_at" db:"paid_at"`
	CreatedAt      time.Time `json:"created_at" db:"created_at"`
}