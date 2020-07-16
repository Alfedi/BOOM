# Bomasy

Bomasy is a simple application to manage your books in a database.

## How to use

To start the server just download dependencies with `mix deps.get` and run the phoenix server with `mix phx.server`.

## Endpoints

### Get a book given ISBN or title

GET `http://localhost:4000/api/books/{isbn_or_title}`

### Add a new book to the database

POST `http://localhost:4000/api/books/add_book`

With the next JSON:
```
{
	"ISBN": 1234567890,
	"title": "title",
	"author": "author",
	"publisher": "publisher",
	"edition": 1
}
```
