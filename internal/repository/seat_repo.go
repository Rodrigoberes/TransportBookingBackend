package repository

import (
	"database/sql"

	"github.com/Rodrigoberes/TransportBookingBackend/internal/models"
)

func CreateSeat(db *sql.DB, seat *models.Seat) error {
	query := `
		INSERT INTO seats (vehicle_id, seat_number, seat_type, row_number, column_position, price_modifier, is_available, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())
		RETURNING id`

	return db.QueryRow(query, seat.VehicleID, seat.SeatNumber, seat.SeatType, seat.RowNumber, seat.ColumnPosition, seat.PriceModifier, seat.IsAvailable).Scan(&seat.ID)
}

func GetSeatByID(db *sql.DB, id int) (*models.Seat, error) {
	var seat models.Seat
	query := `SELECT id, vehicle_id, seat_number, seat_type, row_number, column_position, price_modifier, is_available, created_at FROM seats WHERE id = $1`

	err := db.QueryRow(query, id).Scan(
		&seat.ID, &seat.VehicleID, &seat.SeatNumber, &seat.SeatType, &seat.RowNumber, &seat.ColumnPosition, &seat.PriceModifier, &seat.IsAvailable, &seat.CreatedAt,
	)
	if err != nil {
		return nil, err
	}

	return &seat, nil
}

func GetSeatsByVehicleID(db *sql.DB, vehicleID int) ([]models.Seat, error) {
	query := `SELECT id, vehicle_id, seat_number, seat_type, row_number, column_position, price_modifier, is_available, created_at FROM seats WHERE vehicle_id = $1 ORDER BY row_number, column_position`

	rows, err := db.Query(query, vehicleID)
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

func UpdateSeat(db *sql.DB, seat *models.Seat) error {
	query := `
		UPDATE seats
		SET vehicle_id = $2, seat_number = $3, seat_type = $4, row_number = $5, column_position = $6, price_modifier = $7, is_available = $8
		WHERE id = $1`

	_, err := db.Exec(query, seat.ID, seat.VehicleID, seat.SeatNumber, seat.SeatType, seat.RowNumber, seat.ColumnPosition, seat.PriceModifier, seat.IsAvailable)
	return err
}

func DeleteSeat(db *sql.DB, id int) error {
	query := `DELETE FROM seats WHERE id = $1`
	_, err := db.Exec(query, id)
	return err
}