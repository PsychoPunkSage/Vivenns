/* <3.> CREATE A UTILITY FUNCTION:: CONNECTION TO DB */

package models

import (
	"gorm.io/driver/sqlite" // database driver
	"gorm.io/gorm"
)

// "DB" is assigned a pointer to a <<GORM database object>>.
var DB *gorm.DB

func ConnectDatabase() {
	// 1. Open the DB + initializes a GORM db connection object
	database, err := gorm.Open(sqlite.Open("test.db"), &gorm.Config{})

	if err != nil {
		println("Error connecting database!!")
	}

	err = database.AutoMigrate(&Book{})

	if err != nil {
		return
	}

	DB = database
}
