package repository

import (
	"database/sql"

	"github.com/Rodrigoberes/TransportBookingBackend/internal/models"
)

func CreateRoute(db *sql.DB, route *models.Route) error {
	query := `
		INSERT INTO routes (company_id, origin_city, origin_terminal, destination_city, destination_terminal, distance_km, estimated_duration_minutes, base_price, is_active, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, NOW(), NOW())
		RETURNING id`

	return db.QueryRow(query, route.CompanyID, route.OriginCity, route.OriginTerminal, route.DestinationCity, route.DestinationTerminal, route.DistanceKm, route.EstimatedDurationMinutes, route.BasePrice, route.IsActive).Scan(&route.ID)
}

func GetRouteByID(db *sql.DB, id int) (*models.Route, error) {
	var route models.Route
	query := `SELECT id, company_id, origin_city, origin_terminal, destination_city, destination_terminal, distance_km, estimated_duration_minutes, base_price, is_active, created_at, updated_at FROM routes WHERE id = $1`

	err := db.QueryRow(query, id).Scan(
		&route.ID, &route.CompanyID, &route.OriginCity, &route.OriginTerminal, &route.DestinationCity, &route.DestinationTerminal, &route.DistanceKm, &route.EstimatedDurationMinutes, &route.BasePrice, &route.IsActive, &route.CreatedAt, &route.UpdatedAt,
	)
	if err != nil {
		return nil, err
	}

	return &route, nil
}

func GetAllRoutes(db *sql.DB) ([]models.Route, error) {
	query := `SELECT id, company_id, origin_city, origin_terminal, destination_city, destination_terminal, distance_km, estimated_duration_minutes, base_price, is_active, created_at, updated_at FROM routes ORDER BY origin_city, destination_city`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var routes []models.Route
	for rows.Next() {
		var route models.Route
		err := rows.Scan(
			&route.ID, &route.CompanyID, &route.OriginCity, &route.OriginTerminal, &route.DestinationCity, &route.DestinationTerminal, &route.DistanceKm, &route.EstimatedDurationMinutes, &route.BasePrice, &route.IsActive, &route.CreatedAt, &route.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		routes = append(routes, route)
	}

	return routes, nil
}

func UpdateRoute(db *sql.DB, route *models.Route) error {
	query := `
		UPDATE routes
		SET company_id = $2, origin_city = $3, origin_terminal = $4, destination_city = $5, destination_terminal = $6, distance_km = $7, estimated_duration_minutes = $8, base_price = $9, is_active = $10, updated_at = NOW()
		WHERE id = $1`

	_, err := db.Exec(query, route.ID, route.CompanyID, route.OriginCity, route.OriginTerminal, route.DestinationCity, route.DestinationTerminal, route.DistanceKm, route.EstimatedDurationMinutes, route.BasePrice, route.IsActive)
	return err
}

func DeleteRoute(db *sql.DB, id int) error {
	query := `DELETE FROM routes WHERE id = $1`
	_, err := db.Exec(query, id)
	return err
}