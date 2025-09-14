package services

import (
	"database/sql"
	"errors"

	"github.com/Rodrigoberes/TransportBookingBackend/internal/models"
	"github.com/Rodrigoberes/TransportBookingBackend/internal/repository"
	"github.com/Rodrigoberes/TransportBookingBackend/internal/utils"
	"golang.org/x/crypto/bcrypt"
)

func RegisterUser(db *sql.DB, user *models.User) error {
	// Hash password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(user.Password), bcrypt.DefaultCost)
	if err != nil {
		return err
	}
	user.Password = string(hashedPassword)

	return repository.CreateUser(db, user)
}

func AuthenticateUser(db *sql.DB, email, password string) (string, error) {
	user, err := repository.GetUserByEmail(db, email)
	if err != nil {
		return "", err
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password)); err != nil {
		return "", errors.New("invalid credentials")
	}

	// Generate JWT token
	token, err := utils.GenerateJWT(user.ID, "your-secret-key") // Should use config
	if err != nil {
		return "", err
	}

	return token, nil
}