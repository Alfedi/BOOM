# BOOM

BOOM is a simple application to manage your books in a database.

## How to use

Install `elixir` and `postgresql` like so:

ArchLinux based systems:
```bash
sudo pacman -S elixir
sudo pacman -S postgresql
```
Debian based systems:
```bash
wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && sudo dpkg -i erlang-solutions_2.0_all.deb
sudo apt-get update
sudo apt-get install esl-erlang
sudo apt-get install elixir

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib
```

Now that postgresql is installed start it with `systemctl start postgresql.service`.

You will also need to install GNU Make.

The first time you need to run `make install` to get everything updated.
In order to start the server you need to run the `make start` command.

## Endpoints

All the endpoints require the header:
  - `Content-Type: application/json`

### Get a book given ISBN or title

GET `http://localhost:4000/api/books/<isbn>`

### Add a new book to the database

POST `http://localhost:4000/api/books`

With the next JSON:
```
{
    "ISBN": 1234567890,
    "title": "title",
    "author": "author",
    "edition": 1
    "publisher": "publisher"
}
```

### Get all books (limit 50 by default)

GET `http://localhost:4000/api/books`

### Get books filtering

GET `http://localhost:4000/api/books?limit=10&title=Sample Title`

Possible query params:
 - title
 - author
 - publisher
 - edition (pending)

### Very special thanks
To [@samgh96](https://github.com/samgh96) for suggesting such an incredible name and not letting me keep the awful one.
