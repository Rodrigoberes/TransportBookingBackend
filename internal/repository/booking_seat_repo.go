package repository

import (
	"database/sql"

	"github.com/Rodrigoberes/TransportBookingBackend/internal/models"
)

// DBInterface represents database operations interface
type DBInterface interface {
	Query(query string, args ...interface{}) (*sql.Rows, error)
	QueryRow(query string, args ...interface{}) *sql.Row
	Exec(query string, args ...interface{}) (sql.Result, error)
}

func CreateBookingSeat(db DBInterface, bookingSeat *models.BookingSeat) error {
	query := `
		INSERT INTO booking_seats (booking_id, seat_id, created_at)
		VALUES ($1, $2, NOW())
		RETURNING id`

	return db.QueryRow(query, bookingSeat.BookingID, bookingSeat.SeatID).Scan(&bookingSeat.ID)
}

func GetBookingSeatsByBookingID(db *sql.DB, bookingID int) ([]models.BookingSeat, error) {
	query := `SELECT id, booking_id, seat_id, created_at FROM booking_seats WHERE booking_id = $1`

	rows, err := db.Query(query, bookingID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var bookingSeats []models.BookingSeat
	for rows.Next() {
		var bookingSeat models.BookingSeat
		err := rows.Scan(
			&bookingSeat.ID, &bookingSeat.BookingID, &bookingSeat.SeatID, &bookingSeat.CreatedAt,
		)
		if err != nil {
			return nil, err
		}
		bookingSeats = append(bookingSeats, bookingSeat)
	}

	return bookingSeats, nil
}

func GetAvailableSeatsForSchedule(db DBInterface, scheduleID int, travelDate string) ([]models.Seat, error) {
	query := `
		SELECT s.id, s.vehicle_id, s.seat_number, s.seat_type, s.row_number, s.column_position, s.price_modifier, s.is_available, s.created_at
		FROM seats s
		JOIN schedules sch ON s.vehicle_id = sch.vehicle_id
		WHERE sch.id = $1
		AND s.is_available = true
		AND NOT EXISTS (
			SELECT 1 FROM booking_seats bs
			JOIN bookings b ON bs.booking_id = b.id
			WHERE bs.seat_id = s.id
			AND b.schedule_id = $1
			AND b.travel_date::date = $2::date
			AND b.booking_status IN ('confirmed', 'pending')
		)
		ORDER BY s.row_number, s.column_position`

	rows, err := db.Query(query, scheduleID, travelDate)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var seats []models.Seat
	for rows.Next() {
		var seat models.Seat
		err := rows.Scan(
			&seat.ID, &seat.VehicleID, &seat.SeatNumber, &seat.SeatType, &seat.RowNumber, &seat.ColumnPosition, &seat.PriceModifier, &seat.IsAvailable, &seat.CreatedAt,
		)
		if err != nil {
			return nil, err
		}
		seats = append(seats, seat)
	}

	return seats, nil
}

func UpdateSeatAvailability(db DBInterface, seatID int, isAvailable bool) error {
	query := `UPDATE seats SET is_available = $2 WHERE id = $1`
	_, err := db.Exec(query, seatID, isAvailable)
	return err
}

func DeleteBookingSeat(db *sql.DB, bookingID int, seatID int) error {
	query := `DELETE FROM booking_seats WHERE booking_id = $1 AND seat_id = $2`
	_, err := db.Exec(query, bookingID, seatID)
	return err
}