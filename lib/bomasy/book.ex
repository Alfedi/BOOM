defmodule Bomasy.Book do
  alias Bomasy.Models.Books

  def add_book(isbn, title, author, publisher, edition) do
    case get_book(isbn) do
      {:error, _} ->
        Books.insert_book(%Books{
          ISBN: isbn,
          title: title,
          author: author,
          publisher: publisher,
          edition: edition
        })

      {:ok, _} ->
        {:error, {:error_already_exist, "The book already exists"}}
    end
  end

  # Need a better way to do this
  def get_book(isbn) when is_integer(isbn) do
    case Books |> Bomasy.Repo.get_by(ISBN: isbn) do
      nil ->
        {:error, {:error_not_found, "Book not found"}}

      book ->
        {:ok, book}
    end
  end

  def get_book(title) when is_binary(title) do
    case Books |> Bomasy.Repo.get_by(title: title) do
      nil ->
        {:error, {:error_not_found, "Book not found"}}

      book ->
        {:ok, book}
    end
  end
end
