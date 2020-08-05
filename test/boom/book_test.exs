defmodule Boom.BookTest do
  use Boom.DataCase

  alias Boom.Book

  describe "books" do
    alias Boom.Book.Books

    @valid_attrs %{ISBN: 42, author: "some author", borrowed_by: "some borrowed_by", edition: 42, is_borrowed: true, publisher: "some publisher", title: "some title"}
    @update_attrs %{ISBN: 43, author: "some updated author", borrowed_by: "some updated borrowed_by", edition: 43, is_borrowed: false, publisher: "some updated publisher", title: "some updated title"}
    @invalid_attrs %{ISBN: nil, author: nil, borrowed_by: nil, edition: nil, is_borrowed: nil, publisher: nil, title: nil}

    def books_fixture(attrs \\ %{}) do
      {:ok, books} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Book.create_books()

      books
    end

    test "list_books/0 returns all books" do
      books = books_fixture()
      assert Book.list_books() == [books]
    end

    test "get_books!/1 returns the books with given id" do
      books = books_fixture()
      assert Book.get_books!(books.id) == books
    end

    test "create_books/1 with valid data creates a books" do
      assert {:ok, %Books{} = books} = Book.create_books(@valid_attrs)
      assert books.ISBN == 42
      assert books.author == "some author"
      assert books.borrowed_by == "some borrowed_by"
      assert books.edition == 42
      assert books.is_borrowed == true
      assert books.publisher == "some publisher"
      assert books.title == "some title"
    end

    test "create_books/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Book.create_books(@invalid_attrs)
    end

    test "update_books/2 with valid data updates the books" do
      books = books_fixture()
      assert {:ok, %Books{} = books} = Book.update_books(books, @update_attrs)
      assert books.ISBN == 43
      assert books.author == "some updated author"
      assert books.borrowed_by == "some updated borrowed_by"
      assert books.edition == 43
      assert books.is_borrowed == false
      assert books.publisher == "some updated publisher"
      assert books.title == "some updated title"
    end

    test "update_books/2 with invalid data returns error changeset" do
      books = books_fixture()
      assert {:error, %Ecto.Changeset{}} = Book.update_books(books, @invalid_attrs)
      assert books == Book.get_books!(books.id)
    end

    test "delete_books/1 deletes the books" do
      books = books_fixture()
      assert {:ok, %Books{}} = Book.delete_books(books)
      assert_raise Ecto.NoResultsError, fn -> Book.get_books!(books.id) end
    end

    test "change_books/1 returns a books changeset" do
      books = books_fixture()
      assert %Ecto.Changeset{} = Book.change_books(books)
    end
  end
end
