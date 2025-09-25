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

func GetAllUsers(db *sql.DB) ([]models.User, error) {
	query := `SELECT id, email, password_hash, first_name, last_name, phone, document_type, document_number, is_active, created_at, updated_at FROM users ORDER BY created_at DESC`

	rows, err := db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var users []models.User
	for rows.Next() {
		var user models.User
		err := rows.Scan(
			&user.ID, &user.Email, &user.Password, &user.FirstName, &user.LastName,
			&user.Phone, &user.DocumentType, &user.DocumentNumber, &user.IsActive,
			&user.CreatedAt, &user.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		users = append(users, user)
	}

	return users, nil
}

func SearchUsers(db *sql.DB, query string) ([]models.User, error) {
	searchQuery := `
		SELECT id, email, password_hash, first_name, last_name, phone, document_type, document_number, is_active, created_at, updated_at
		FROM users
		WHERE first_name ILIKE $1 OR last_name ILIKE $1 OR email ILIKE $1
		ORDER BY first_name, last_name`

	rows, err := db.Query(searchQuery, "%"+query+"%")
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var users []models.User
	for rows.Next() {
		var user models.User
		err := rows.Scan(
			&user.ID, &user.Email, &user.Password, &user.FirstName, &user.LastName,
			&user.Phone, &user.DocumentType, &user.DocumentNumber, &user.IsActive,
			&user.CreatedAt, &user.UpdatedAt,
		)
		if err != nil {
			return nil, err
		}
		users = append(users, user)
	}

	return users, nil
}

func UpdateUser(db *sql.DB, user *models.User) error {
	query := `
		UPDATE users
		SET email = $2, first_name = $3, last_name = $4, phone = $5,
		    document_type = $6, document_number = $7, is_active = $8, updated_at = NOW()
		WHERE id = $1`

	_, err := db.Exec(query, user.ID, user.Email, user.FirstName, user.LastName,
		user.Phone, user.DocumentType, user.DocumentNumber, user.IsActive)
	return err
}

func DeleteUser(db *sql.DB, id int) error {
	query := `DELETE FROM users WHERE id = $1`
	_, err := db.Exec(query, id)
	return err
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