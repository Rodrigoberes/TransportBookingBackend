package repository

import (
	"database/sql"

	"github.com/Rodrigoberes/TransportBookingBackend/internal/models"
)

func CreateCompany(db *sql.DB, company *models.Company) error {
	query := `
		INSERT INTO companies (name, cuit, phone, email, address, icon, is_active, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, NOW(), NOW())
		RETURNING id`

	return db.QueryRow(query, company.Name, company.Cuit, company.Phone, company.Email, company.Address, company.Icon, company.IsActive).Scan(&company.ID)
}

func GetCompanyByID(db *sql.DB, id int) (*models.Company, error) {
	var company models.Company
	query := `SELECT id, name, cuit, phone, email, address, icon, is_active, created_at, updated_at FROM companies WHERE id = $1`

	err := db.QueryRow(query, id).Scan(
		&company.ID, &company.Name, &company.Cuit, &company.Phone, &company.Email, &company.Address, &company.Icon, &company.IsActive, &company.CreatedAt, &company.UpdatedAt,
	)
	if err != nil {
		return nil, err
	}

	return &company, nil
}

func GetAllCompanies(db *sql.DB) ([]models.Company, error) {
	query := `SELECT id, name, cuit, phone, email, address, icon, is_active, created_at, updated_at FROM companies ORDER BY name`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var companies []models.Company
	for rows.Next() {
		var company models.Company
		err := rows.Scan(
			&company.ID, &company.Name, &company.Cuit, &company.Phone, &company.Email, &company.Address, &company.Icon, &company.IsActive, &company.CreatedAt, &company.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		companies = append(companies, company)
	}

	return companies, nil
}

func UpdateCompany(db *sql.DB, company *models.Company) error {
	query := `
		UPDATE companies
		SET name = $2, cuit = $3, phone = $4, email = $5, address = $6, icon = $7, is_active = $8, updated_at = NOW()
		WHERE id = $1`

	_, err := db.Exec(query, company.ID, company.Name, company.Cuit, company.Phone, company.Email, company.Address, company.Icon, company.IsActive)
	return err
}

func DeleteCompany(db *sql.DB, id int) error {
	query := `DELETE FROM companies WHERE id = $1`
	_, err := db.Exec(query, id)
	return err
}