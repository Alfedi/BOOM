defmodule BoomWeb.BookView do
  use BoomWeb, :view

  def render("book.json", %{book: book}) do
    book_json(book)
  end

  @book_fields [:ISBN, :title, :author, :edition, :publisher]
  def book_json(book) do
    Map.take(book, @book_fields)
  end
end
