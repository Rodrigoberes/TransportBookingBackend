package repository

import (
	"database/sql"

	"github.com/Rodrigoberes/TransportBookingBackend/internal/models"
)

func CreatePayment(db *sql.DB, payment *models.Payment) error {
	query := `
		INSERT INTO payments (booking_id, amount, payment_method, payment_status, transaction_id, payment_gateway, paid_at, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())
		RETURNING id`

	return db.QueryRow(query, payment.BookingID, payment.Amount, payment.PaymentMethod, payment.PaymentStatus, payment.TransactionID, payment.PaymentGateway, payment.PaidAt).Scan(&payment.ID)
}

func GetPaymentByID(db *sql.DB, id int) (*models.Payment, error) {
	var payment models.Payment
	query := `SELECT id, booking_id, amount, payment_method, payment_status, transaction_id, payment_gateway, paid_at, created_at FROM payments WHERE id = $1`

	err := db.QueryRow(query, id).Scan(
		&payment.ID, &payment.BookingID, &payment.Amount, &payment.PaymentMethod, &payment.PaymentStatus, &payment.TransactionID, &payment.PaymentGateway, &payment.PaidAt, &payment.CreatedAt,
	)
	if err != nil {
		return nil, err
	}

	return &payment, nil
}

func GetPaymentsByBookingID(db *sql.DB, bookingID int) ([]models.Payment, error) {
	query := `SELECT id, booking_id, amount, payment_method, payment_status, transaction_id, payment_gateway, paid_at, created_at FROM payments WHERE booking_id = $1 ORDER BY created_at`

	rows, err := db.Query(query, bookingID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var payments []models.Payment
	for rows.Next() {
		var payment models.Payment
		err := rows.Scan(
			&payment.ID, &payment.BookingID, &payment.Amount, &payment.PaymentMethod, &payment.PaymentStatus, &payment.TransactionID, &payment.PaymentGateway, &payment.PaidAt, &payment.CreatedAt,
		)
		if err != nil {
			return nil, err
		}
		payments = append(payments, payment)
	}

	return payments, nil
}

func UpdatePayment(db *sql.DB, payment *models.Payment) error {
	query := `
		UPDATE payments
		SET booking_id = $2, amount = $3, payment_method = $4, payment_status = $5, transaction_id = $6, payment_gateway = $7, paid_at = $8
		WHERE id = $1`

	_, err := db.Exec(query, payment.ID, payment.BookingID, payment.Amount, payment.PaymentMethod, payment.PaymentStatus, payment.TransactionID, payment.PaymentGateway, payment.PaidAt)
	return err
}

func DeletePayment(db *sql.DB, id int) error {
	query := `DELETE FROM payments WHERE id = $1`
	_, err := db.Exec(query, id)
	return err
}