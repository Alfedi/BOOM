defmodule Boom.Book do
  alias Boom.Models.Books

  import Ecto.Query

  def add_book(isbn, title, author, publisher, edition) do
    case get_book(isbn) do
      {:ok, %{ISBN: _}} ->
        {:error, {:error_already_exist, "The book already exists"}}

      {_, %{}} ->
        Books.insert_book(%Books{
          ISBN: isbn,
          title: title,
          author: author,
          publisher: publisher,
          edition: edition
        })
    end
  end

  # This huge regex allow us to match ISBN 10 and ISBN 13 with or without minus and spaces.
  def get_book(id) do
    case String.match?(
           id,
           ~r/((978[\--– ])?[0-9][0-9\--– ]{10}[\--– ][0-9xX])|((978)?[0-9]{9}[0-9Xx])/
         ) do
      true ->
        case Books
             |> Boom.Repo.get_by(ISBN: id |> String.replace(~r/(-| )/, "") |> String.upcase()) do
          nil ->
            {:ok, %{}}

          book ->
            {:ok, book}
        end

      false ->
        query =
          from(b in Boom.Models.Books,
            # Simple regex for searching multiple books
            where: ilike(b.title, ^"#{id}%")
          )

        {:ok, Boom.Repo.all(query)}
    end
  end

  def get_books(cursor, filters, limit \\ 50) do
    base_query = from(Boom.Models.Books, as: :book, order_by: :inserted_at)

    query =
      Enum.reduce(filters, base_query, fn {k, v}, query ->
        where(query, [book: book], ilike(field(book, ^k), ^"%#{v}%"))
      end)

    %{entries: entries, metadata: metadata} =
      Boom.Repo.paginate(query, after: cursor, cursor_fields: [:inserted_at], limit: limit)

    {:ok, entries, %{cursor_after: metadata.after, cursor_before: metadata.before}}
  end

  def delete_book(isbn) do
    case get_book(isbn) do
      {:ok, %{ISBN: _} = book} -> Books.remove_book(book)
      {_, %{}} -> {:error, {:book_no_exist, "The books does not exist"}}
    end
  end

  def edit_book(book, new_id, new_title, new_author, new_edition, new_publisher) do
    case String.match?(
           new_id,
           ~r/((978[\--– ])?[0-9][0-9\--– ]{10}[\--– ][0-9xX])|((978)?[0-9]{9}[0-9Xx])/
         ) do
      true ->
        new_isbn = new_id |> String.replace(~r/(-| )/, "") |> String.upcase()

        book
        |> Ecto.Changeset.change(%{
          ISBN: new_isbn,
          title: new_title,
          author: new_author,
          publisher: new_publisher,
          edition: new_edition
        })
        |> Books.edit_book()

      false ->
        {:error, {:error_isbn_not_valid, "The new ISBN is not correct"}}
    end
  end
end
