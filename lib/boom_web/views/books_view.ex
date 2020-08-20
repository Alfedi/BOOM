defmodule BoomWeb.BooksView do
  use BoomWeb, :view

  def render("books.json", %{book_list: book_list}) do
    book_list |> Enum.map(&book_json/1)
  end

  @book_fields [:ISBN, :title, :author, :edition, :publisher]
  def book_json(book) do
    Map.take(book, @book_fields)
  end
end
