/* <1.> SETUP THE SERVER */

package main

import (
	"1_gin_gorm_rest/controllers"
	"1_gin_gorm_rest/models"

	"github.com/gin-gonic/gin"
)

func main() {
	// 1. creating a Router instance from Gin framework (with all the default middleware attached)
	r := gin.Default()

	/* 2a.
	<<gin.H>>  - shorthand for Go map with string keys - gets encoded as JSON object
			   - Returns content type => application/json

	<<ctx.JSON()>>  - Sends a JSON response
				    - First argument sets status code
				    - Second argument is Go struct that gets encoded to JSON

	<<func(ctx *gin.Context)>>  - gin.Context :: a pointer to a Gin Context struct.
								- <ctx> input parameter provides the HTTP request/response context
								- i.e. anonymous function to handle HTTP requests in Gin
	*/

	// r.GET("/", func(ctx *gin.Context) { // route handler for GET requests; Path: '/' i.e. root
	// 	ctx.JSON(http.StatusOK, gin.H{
	// 		"creator": "PsychoPunkSage",
	// 	})
	// })

	/* 2b.
	ANALOGY:: {express.js}
	 - r.GET() is similar to app.get() route handler
	 - ctx similar to request/response objects
	 - ctx.JSON() sends JSON response like res.json()
	*/

	// Connect with DB
	models.ConnectDatabase()

	// Make a GET req ~ Express
	r.GET("/books", controllers.FindBooks)
	r.POST("/books", controllers.CreateBook)
	r.GET("/books/:id", controllers.FindBook) // error in this line
	r.PATCH("/books/id", controllers.UpdateBook)
	r.DELETE("/books/id", controllers.DeleteBook)

	// 3. start the HTTP server and serve HTTP requests based on the routes
	err := r.Run()
	if err != nil {
		return
	}
}
