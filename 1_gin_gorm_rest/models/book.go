/* <2.> BUILD DB MODELS */

package models

type Book struct {
	ID     uint   `json:"id" gorm:"primary_key"`
	Title  string `json:"title"`
	Author string `json:"author"`
}

/*
    ID: An unsigned integer (uint) representing the unique identifier of the book.
    Title: A string containing the title of the book.
    Author: A string containing the author of the book.

json tag:

    <<json:"id">>: This tag specifies how this field should be ""serialized"" and ""deserialized"" when interacting with JSON data. Here, it tells the program to map the ID field to the JSON key "id". This means that when converting a Book struct to JSON, the field's value will be included as a property named "id". Similarly, when parsing JSON data into a Book struct, the program will expect to find an "id" property and use its value to populate the ID field.

gorm tag:

    <<gorm:"primary_key">>: This tag indicates that the ID field is the primary key of the table in the database. This instructs GORM, an object-relational mapper (ORM) for Go, to use this field as the "primary key" when interacting with the database.

*/
