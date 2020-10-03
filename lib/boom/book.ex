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

  # In order to get a successful search the ISBN must be exact.
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
            # Simple regex for searching various books
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
end
