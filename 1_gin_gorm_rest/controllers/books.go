package controllers

import (
	"1_gin_gorm_rest/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// return all books from our database
func FindBooks(ctx *gin.Context) {
	var books []models.Book
	models.DB.Find(&books)

	ctx.JSON(http.StatusOK, gin.H{
		"BookData": books,
	})
}
