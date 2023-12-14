package controllers

import (
	"1_gin_gorm_rest/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

type CreateBookInput struct {
	Title  string `json:"title" binding:"required"`
	Author string `json:"author" binding:"required"`
}

// return all books from our database
func FindBooks(ctx *gin.Context) {
	var books []models.Book
	models.DB.Find(&books)

	ctx.JSON(http.StatusOK, gin.H{
		"BookData": books,
	})
}

func CreateBook(ctx *gin.Context) {
	// 1. Create an input (type: CreateBookInput struct)
	var input CreateBookInput

	err := ctx.BindJSON(&input)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}

	// 2. Create a new book
	book := models.Book{Title: input.Title, Author: input.Author}
	models.DB.Create(&book)

	ctx.JSON(http.StatusOK, gin.H{"data": book})
}
