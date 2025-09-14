package handlers

import (
	"database/sql"
	"net/http"
	"strconv"

	"github.com/Rodrigoberes/TransportBookingBackend/internal/models"
	"github.com/Rodrigoberes/TransportBookingBackend/internal/repository"
	"github.com/gin-gonic/gin"
)

// CreateCompany godoc
// @Summary Create a new company
// @Description Create a new company
// @Tags companies
// @Accept json
// @Produce json
// @Param company body models.Company true "Company data"
// @Success 201 {object} models.Company
// @Failure 400 {object} map[string]string
// @Router /companies [post]
func CreateCompany(c *gin.Context, db *sql.DB) {
	var company models.Company
	if err := c.ShouldBindJSON(&company); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := repository.CreateCompany(db, &company); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, company)
}

// GetCompany godoc
// @Summary Get company by ID
// @Description Get company information by ID
// @Tags companies
// @Accept json
// @Produce json
// @Param id path int true "Company ID"
// @Success 200 {object} models.Company
// @Failure 404 {object} map[string]string
// @Router /companies/{id} [get]
func GetCompany(c *gin.Context, db *sql.DB) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid company ID"})
		return
	}

	company, err := repository.GetCompanyByID(db, id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Company not found"})
		return
	}

	c.JSON(http.StatusOK, company)
}

// GetAllCompanies godoc
// @Summary Get all companies
// @Description Get list of all companies
// @Tags companies
// @Accept json
// @Produce json
// @Success 200 {array} models.Company
// @Router /companies [get]
func GetAllCompanies(c *gin.Context, db *sql.DB) {
	companies, err := repository.GetAllCompanies(db)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, companies)
}

// UpdateCompany godoc
// @Summary Update company
// @Description Update company information
// @Tags companies
// @Accept json
// @Produce json
// @Param id path int true "Company ID"
// @Param company body models.Company true "Company data"
// @Success 200 {object} models.Company
// @Failure 400 {object} map[string]string
// @Router /companies/{id} [put]
func UpdateCompany(c *gin.Context, db *sql.DB) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid company ID"})
		return
	}

	var company models.Company
	if err := c.ShouldBindJSON(&company); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	company.ID = id

	if err := repository.UpdateCompany(db, &company); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, company)
}

// DeleteCompany godoc
// @Summary Delete company
// @Description Delete a company by ID
// @Tags companies
// @Accept json
// @Produce json
// @Param id path int true "Company ID"
// @Success 204
// @Failure 500 {object} map[string]string
// @Router /companies/{id} [delete]
func DeleteCompany(c *gin.Context, db *sql.DB) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid company ID"})
		return
	}

	if err := repository.DeleteCompany(db, id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusNoContent, nil)
}