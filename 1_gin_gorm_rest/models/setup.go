/* <3.> CREATE A UTILITY FUNCTION:: CONNECTION TO DB */

package models

import "gorm.io/gorm"

// "DB" is assigned a pointer to a <<GORM database object>>.
var DB *gorm.DB

func ConnectDatabase() {}
