package repository

import (
	"database/sql"

	"github.com/Rodrigoberes/TransportBookingBackend/internal/models"
)

func CreateUser(db *sql.DB, user *models.User) error {
	query := `
		INSERT INTO users (email, password_hash, first_name, last_name, phone, document_type, document_number, is_active, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, NOW(), NOW())
		RETURNING id`

	return db.QueryRow(query, user.Email, user.Password, user.FirstName, user.LastName, user.Phone, user.DocumentType, user.DocumentNumber, user.IsActive).Scan(&user.ID)
}

func GetUserByEmail(db *sql.DB, email string) (*models.User, error) {
	var user models.User
	query := `SELECT id, email, password_hash, first_name, last_name, phone, document_type, document_number, is_active, created_at, updated_at FROM users WHERE email = $1`

	err := db.QueryRow(query, email).Scan(
		&user.ID, &user.Email, &user.Password, &user.FirstName, &user.LastName, &user.Phone, &user.DocumentType, &user.DocumentNumber, &user.IsActive, &user.CreatedAt, &user.UpdatedAt,
	)
	if err != nil {
		return nil, err
	}

	return &user, nil
}

func GetUserByID(db *sql.DB, id int) (*models.User, error) {
	var user models.User
	query := `SELECT id, email, password_hash, first_name, last_name, phone, document_type, document_number, is_active, created_at, updated_at FROM users WHERE id = $1`

	err := db.QueryRow(query, id).Scan(
		&user.ID, &user.Email, &user.Password, &user.FirstName, &user.LastName, &user.Phone, &user.DocumentType, &user.DocumentNumber, &user.IsActive, &user.CreatedAt, &user.UpdatedAt,
	)
	if err != nil {
		return nil, err
	}

	return &user, nil
}