package repository

import (
	"database/sql"

	"github.com/Rodrigoberes/TransportBookingBackend/internal/models"
)

func CreateSchedule(db *sql.DB, schedule *models.Schedule) error {
	query := `
		INSERT INTO schedules (route_id, vehicle_id, departure_time, arrival_time, days_of_week, valid_from, valid_until, is_active, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, NOW(), NOW())
		RETURNING id`

	return db.QueryRow(query, schedule.RouteID, schedule.VehicleID, schedule.DepartureTime, schedule.ArrivalTime, schedule.DaysOfWeek, schedule.ValidFrom, schedule.ValidUntil, schedule.IsActive).Scan(&schedule.ID)
}

func GetScheduleByID(db *sql.DB, id int) (*models.Schedule, error) {
	var schedule models.Schedule
	query := `SELECT id, route_id, vehicle_id, departure_time, arrival_time, days_of_week, valid_from, valid_until, is_active, created_at, updated_at FROM schedules WHERE id = $1`

	err := db.QueryRow(query, id).Scan(
		&schedule.ID, &schedule.RouteID, &schedule.VehicleID, &schedule.DepartureTime, &schedule.ArrivalTime, &schedule.DaysOfWeek, &schedule.ValidFrom, &schedule.ValidUntil, &schedule.IsActive, &schedule.CreatedAt, &schedule.UpdatedAt,
	)
	if err != nil {
		return nil, err
	}

	return &schedule, nil
}

func GetAllSchedules(db *sql.DB) ([]models.Schedule, error) {
	query := `SELECT id, route_id, vehicle_id, departure_time, arrival_time, days_of_week, valid_from, valid_until, is_active, created_at, updated_at FROM schedules ORDER BY valid_from`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var schedules []models.Schedule
	for rows.Next() {
		var schedule models.Schedule
		err := rows.Scan(
			&schedule.ID, &schedule.RouteID, &schedule.VehicleID, &schedule.DepartureTime, &schedule.ArrivalTime, &schedule.DaysOfWeek, &schedule.ValidFrom, &schedule.ValidUntil, &schedule.IsActive, &schedule.CreatedAt, &schedule.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		schedules = append(schedules, schedule)
	}

	return schedules, nil
}

func UpdateSchedule(db *sql.DB, schedule *models.Schedule) error {
	query := `
		UPDATE schedules
		SET route_id = $2, vehicle_id = $3, departure_time = $4, arrival_time = $5, days_of_week = $6, valid_from = $7, valid_until = $8, is_active = $9, updated_at = NOW()
		WHERE id = $1`

	_, err := db.Exec(query, schedule.ID, schedule.RouteID, schedule.VehicleID, schedule.DepartureTime, schedule.ArrivalTime, schedule.DaysOfWeek, schedule.ValidFrom, schedule.ValidUntil, schedule.IsActive)
	return err
}

func DeleteSchedule(db *sql.DB, id int) error {
	query := `DELETE FROM schedules WHERE id = $1`
	_, err := db.Exec(query, id)
	return err
}