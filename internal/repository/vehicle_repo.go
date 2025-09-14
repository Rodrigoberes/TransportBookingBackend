package repository

import (
	"database/sql"
	"encoding/json"

	"github.com/Rodrigoberes/TransportBookingBackend/internal/models"
)

func CreateVehicle(db *sql.DB, vehicle *models.Vehicle) error {
	seatLayoutJSON, _ := json.Marshal(vehicle.SeatLayout)
	amenitiesJSON, _ := json.Marshal(vehicle.Amenities)

	query := `
		INSERT INTO vehicles (company_id, license_plate, vehicle_type, brand, model, year, total_seats, seat_layout, amenities, is_active, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, NOW(), NOW())
		RETURNING id`

	return db.QueryRow(query, vehicle.CompanyID, vehicle.LicensePlate, vehicle.VehicleType, vehicle.Brand, vehicle.Model, vehicle.Year, vehicle.TotalSeats, seatLayoutJSON, amenitiesJSON, vehicle.IsActive).Scan(&vehicle.ID)
}

func GetVehicleByID(db *sql.DB, id int) (*models.Vehicle, error) {
	var vehicle models.Vehicle
	var seatLayoutJSON, amenitiesJSON []byte

	query := `SELECT id, company_id, license_plate, vehicle_type, brand, model, year, total_seats, seat_layout, amenities, is_active, created_at, updated_at FROM vehicles WHERE id = $1`

	err := db.QueryRow(query, id).Scan(
		&vehicle.ID, &vehicle.CompanyID, &vehicle.LicensePlate, &vehicle.VehicleType, &vehicle.Brand, &vehicle.Model, &vehicle.Year, &vehicle.TotalSeats, &seatLayoutJSON, &amenitiesJSON, &vehicle.IsActive, &vehicle.CreatedAt, &vehicle.UpdatedAt,
	)
	if err != nil {
		return nil, err
	}

	json.Unmarshal(seatLayoutJSON, &vehicle.SeatLayout)
	json.Unmarshal(amenitiesJSON, &vehicle.Amenities)

	return &vehicle, nil
}

func GetAllVehicles(db *sql.DB) ([]models.Vehicle, error) {
	query := `SELECT id, company_id, license_plate, vehicle_type, brand, model, year, total_seats, seat_layout, amenities, is_active, created_at, updated_at FROM vehicles ORDER BY license_plate`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var vehicles []models.Vehicle
	for rows.Next() {
		var vehicle models.Vehicle
		var seatLayoutJSON, amenitiesJSON []byte
		err := rows.Scan(
			&vehicle.ID, &vehicle.CompanyID, &vehicle.LicensePlate, &vehicle.VehicleType, &vehicle.Brand, &vehicle.Model, &vehicle.Year, &vehicle.TotalSeats, &seatLayoutJSON, &amenitiesJSON, &vehicle.IsActive, &vehicle.CreatedAt, &vehicle.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		json.Unmarshal(seatLayoutJSON, &vehicle.SeatLayout)
		json.Unmarshal(amenitiesJSON, &vehicle.Amenities)
		vehicles = append(vehicles, vehicle)
	}

	return vehicles, nil
}

func UpdateVehicle(db *sql.DB, vehicle *models.Vehicle) error {
	seatLayoutJSON, _ := json.Marshal(vehicle.SeatLayout)
	amenitiesJSON, _ := json.Marshal(vehicle.Amenities)

	query := `
		UPDATE vehicles
		SET company_id = $2, license_plate = $3, vehicle_type = $4, brand = $5, model = $6, year = $7, total_seats = $8, seat_layout = $9, amenities = $10, is_active = $11, updated_at = NOW()
		WHERE id = $1`

	_, err := db.Exec(query, vehicle.ID, vehicle.CompanyID, vehicle.LicensePlate, vehicle.VehicleType, vehicle.Brand, vehicle.Model, vehicle.Year, vehicle.TotalSeats, seatLayoutJSON, amenitiesJSON, vehicle.IsActive)
	return err
}

func DeleteVehicle(db *sql.DB, id int) error {
	query := `DELETE FROM vehicles WHERE id = $1`
	_, err := db.Exec(query, id)
	return err
}