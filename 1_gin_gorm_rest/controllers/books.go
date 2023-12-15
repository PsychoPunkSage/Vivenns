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

type UpdateBookInput struct {
	Title  string `json:"title"`
	Author string `json:"author"`
}

// /////////////
// FIND_BOOKS //
// /////////////
// return all books from our database
func FindBooks(ctx *gin.Context) {
	var books []models.Book
	models.DB.Find(&books)

	ctx.JSON(http.StatusOK, gin.H{
		"BooksData": books,
	})
}

// ////////////
// FIND_BOOK //
// ////////////

// return particular book from our database
// func FindBook(ctx *gin.Context) {
// 	var book models.Book

// 	err := models.DB.Where("id = ?", ctx.Param("id")).First(&book).Error
// 	if err != nil {
// 		ctx.JSON(http.StatusBadRequest, gin.H{
// 			"Error": "Record Not Found",
// 		})
// 	}

//		ctx.JSON(http.StatusOK, gin.H{
//			"BookData": book,
//		})
//	}
func FindBook(c *gin.Context) { // Get model if exist
	var book models.Book

	if err := models.DB.Where("id = ?", c.Param("id")).First(&book).Error; err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Record not found!"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"data": book})
}

// //////////////
// CREATE_BOOK //
// //////////////
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

// //////////////
// UPDATE_BOOK //
// //////////////
func UpdateBook(ctx *gin.Context) {
	// Find the Book
	var book models.Book
	err := models.DB.Where("id = ?", ctx.Param("id")).First(&book).Error

	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"Error": "Book Does Not Exist"})
	}

	// Validate the input
	var input UpdateBookInput
	err1 := ctx.ShouldBindJSON(&input)

	if err1 != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"Error": err1.Error()})
		return
	}

	// Update the input
	models.DB.Model(&book).Updates(input)

	ctx.JSON(http.StatusOK, gin.H{
		"book": book,
	})
}

// //////////////
// DELETE_BOOK //
// //////////////
func DeleteBook(ctx *gin.Context) {
	// Find the book
	var book models.Book
	err := models.DB.Where("id =  ?", ctx.Param("id")).First(&book).Error
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{
			"Error":   "Books Does not exist",
			"Browser": err.Error(),
		})
	}

	// Delete book
	models.DB.Delete(&book)
	ctx.JSON(http.StatusOK, gin.H{
		"Delete-Status": true,
	})
}
