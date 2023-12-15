/* <3.> CREATE A UTILITY FUNCTION:: CONNECTION TO DB */

package models

import (
	"gorm.io/driver/sqlite" // database driver
	"gorm.io/gorm"
)

// "DB" is assigned a pointer to a <<GORM database object>>.
var DB *gorm.DB

func ConnectDatabase() {
	// 1. Open the DB + Use `GORM`` to connect to a SQLite database file
	database, err := gorm.Open(sqlite.Open("test.db"), &gorm.Config{})

	if err != nil {
		println("Error connecting database!!")
	}

	// migrate the Book model. Creates the table if it does not already exist
	err = database.AutoMigrate(&Book{})

	if err != nil {
		return
	}

	// Assign the db connection to global var
	DB = database
}
