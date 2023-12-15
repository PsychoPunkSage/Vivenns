package controllers

import (
	"1_gin_gorm_rest/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

// `....Text inside....` :: For Serialization + Deserialization || AS Go doesn't support JSON
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
	// <<books>> empty slice to hold the list of books
	var books []models.Book

	// Use the DB connection to retrieve all Book models and store them in <<books>>
	models.DB.Find(&books)

	// Return response as JSON with HTTP 200 OK status + books data (as JSON)
	ctx.JSON(http.StatusOK, gin.H{
		"BooksData": books,
	})
}

// ////////////
// FIND_BOOK //
// ////////////

// return particular book from our database
func FindBook(ctx *gin.Context) {
	// <<book>> var. to hold the "Book" struct i.e. for single book
	var book models.Book

	// Fetch the book with ID
	/*
		<<ctx.Param("id")>> retrieves the "id" parameter that was passed in the API URL.
		<<.First(&book)>> retrieve the FIRST matching record, and it will be loaded into the book struct
		<<Error>> executes the SQL query and returns any error encountered
	*/
	err := models.DB.Where("id = ?", ctx.Param("id")).First(&book).Error
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{
			"Error": "Record Not Found",
		})
	}

	// Return response as JSON with HTTP 200 OK status + book data (as JSON)
	ctx.JSON(http.StatusOK, gin.H{
		"BookData": book,
	})
}

// //////////////
// CREATE_BOOK //
// //////////////
func CreateBook(ctx *gin.Context) {
	// 1. Create an input (type: CreateBookInput struct)
	var input CreateBookInput

	// 1a. Bind the JSON body data to input struct || fails will be recorded in `err`
	err := ctx.BindJSON(&input)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{
			"error": err.Error(),
		})
		return
	}

	// 2. Create a new book
	book := models.Book{Title: input.Title, Author: input.Author}

	// 3. Insert the new book record using the GORM DB connection
	models.DB.Create(&book)

	// 4. Return response as JSON with HTTP 200 OK status + book data (as JSON)
	ctx.JSON(http.StatusOK, gin.H{"data": book})
}

// //////////////
// UPDATE_BOOK //
// //////////////
func UpdateBook(ctx *gin.Context) {
	// <<book>> var. to hold the "Book" struct i.e. for single book
	var book models.Book

	// Fetch the book with ID
	/*
		<<ctx.Param("id")>> retrieves the "id" parameter that was passed in the API URL.
		<<.First(&book)>> retrieve the FIRST matching record, and it will be loaded into the book struct
		<<Error>> executes the SQL query and returns any error encountered
	*/
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

	// Return response as JSON with HTTP 200 OK status + updatedBook data (as JSON)
	ctx.JSON(http.StatusOK, gin.H{
		"book": book,
	})
}

// //////////////
// DELETE_BOOK //
// //////////////
func DeleteBook(ctx *gin.Context) {
	// <<book>> var. to hold the "Book" struct i.e. for single book
	var book models.Book

	// Fetch the book with ID
	/*
		<<ctx.Param("id")>> retrieves the "id" parameter that was passed in the API URL.
		<<.First(&book)>> retrieve the FIRST matching record, and it will be loaded into the book struct
		<<Error>> executes the SQL query and returns any error encountered
	*/
	err := models.DB.Where("id =  ?", ctx.Param("id")).First(&book).Error

	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{
			"Error":   "Books Does not exist",
			"Browser": err.Error(),
		})
	}

	// Delete book
	models.DB.Delete(&book)

	// Return response as JSON with HTTP 200 OK status + Status
	ctx.JSON(http.StatusOK, gin.H{
		"Delete-Status": true,
	})
}
