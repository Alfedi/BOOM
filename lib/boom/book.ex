defmodule Boom.Book do
  alias Boom.Models.Books

  import Ecto.Query

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

  # In order to get a successful search the ISBN must be exact.
  def get_book(isbn) when is_integer(isbn) do
    case Books |> Boom.Repo.get_by(ISBN: isbn) do
      nil ->
        {:error, {:error_not_found, "Book not found"}}

      book ->
        {:ok, book}
    end
  end

  def get_book(title) when is_binary(title) do
    query =
      from(b in Boom.Models.Books,
        # Simple regex for searching various books
        where: ilike(b.title, ^"#{title}%")
      )

    {:ok, Boom.Repo.all(query)}
  end

  def get_books(cursor, limit \\ 2) do
    query = from(b in Boom.Models.Books, order_by: b.inserted_at)

    %{entries: entries, metadata: metadata} =
      Boom.Repo.paginate(query, after: cursor, cursor_fields: [:inserted_at], limit: limit)

    {:ok, entries, %{cursor_after: metadata.after, cursor_before: metadata.before}}
  end
end
