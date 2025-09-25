package repository

import (
	"database/sql"

	"github.com/Rodrigoberes/TransportBookingBackend/internal/models"
)

func CreateBooking(db DBInterface, booking *models.Booking) error {
	query := `
		INSERT INTO bookings (user_id, schedule_id, booking_code, travel_date, departure_datetime, passenger_name, passenger_document, passenger_phone, total_amount, payment_status, booking_status, payment_method, notes, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, NOW(), NOW())
		RETURNING id`

	return db.QueryRow(query, booking.UserID, booking.ScheduleID, booking.BookingCode, booking.TravelDate, booking.DepartureDatetime, booking.PassengerName, booking.PassengerDocument, booking.PassengerPhone, booking.TotalAmount, booking.PaymentStatus, booking.BookingStatus, booking.PaymentMethod, booking.Notes).Scan(&booking.ID)
}

func GetBookingByID(db *sql.DB, id int) (*models.Booking, error) {
	var booking models.Booking
	query := `SELECT id, user_id, schedule_id, booking_code, travel_date, departure_datetime, passenger_name, passenger_document, passenger_phone, total_amount, payment_status, booking_status, payment_method, notes, created_at, updated_at FROM bookings WHERE id = $1`

	err := db.QueryRow(query, id).Scan(
		&booking.ID, &booking.UserID, &booking.ScheduleID, &booking.BookingCode, &booking.TravelDate, &booking.DepartureDatetime, &booking.PassengerName, &booking.PassengerDocument, &booking.PassengerPhone, &booking.TotalAmount, &booking.PaymentStatus, &booking.BookingStatus, &booking.PaymentMethod, &booking.Notes, &booking.CreatedAt, &booking.UpdatedAt,
	)
	if err != nil {
		return nil, err
	}

	return &booking, nil
}

func GetBookingsByUserID(db *sql.DB, userID int) ([]models.Booking, error) {
	query := `SELECT id, user_id, schedule_id, booking_code, travel_date, departure_datetime, passenger_name, passenger_document, passenger_phone, total_amount, payment_status, booking_status, payment_method, notes, created_at, updated_at FROM bookings WHERE user_id = $1 ORDER BY created_at DESC`

	rows, err := db.Query(query, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var bookings []models.Booking
	for rows.Next() {
		var booking models.Booking
		err := rows.Scan(
			&booking.ID, &booking.UserID, &booking.ScheduleID, &booking.BookingCode, &booking.TravelDate, &booking.DepartureDatetime, &booking.PassengerName, &booking.PassengerDocument, &booking.PassengerPhone, &booking.TotalAmount, &booking.PaymentStatus, &booking.BookingStatus, &booking.PaymentMethod, &booking.Notes, &booking.CreatedAt, &booking.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		bookings = append(bookings, booking)
	}

	return bookings, nil
}

func UpdateBooking(db *sql.DB, booking *models.Booking) error {
	query := `
		UPDATE bookings
		SET user_id = $2, schedule_id = $3, booking_code = $4, travel_date = $5, departure_datetime = $6, passenger_name = $7, passenger_document = $8, passenger_phone = $9, total_amount = $10, payment_status = $11, booking_status = $12, payment_method = $13, notes = $14, updated_at = NOW()
		WHERE id = $1`

	_, err := db.Exec(query, booking.ID, booking.UserID, booking.ScheduleID, booking.BookingCode, booking.TravelDate, booking.DepartureDatetime, booking.PassengerName, booking.PassengerDocument, booking.PassengerPhone, booking.TotalAmount, booking.PaymentStatus, booking.BookingStatus, booking.PaymentMethod, booking.Notes)
	return err
}

func DeleteBooking(db *sql.DB, id int) error {
	query := `DELETE FROM bookings WHERE id = $1`
	_, err := db.Exec(query, id)
	return err
}