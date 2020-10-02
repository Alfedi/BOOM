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

  # This huge regex allow us to match ISBN 10 and ISBN 13 with or without minus.
  def get_book(id) do
    case String.match?(
           id,
           ~r/((978[\--– ])?[0-9][0-9\--– ]{10}[\--– ][0-9xX])|((978)?[0-9]{9}[0-9Xx])/
         ) do
      true ->
        case Books |> Boom.Repo.get_by(ISBN: id |> String.replace("-", "") |> String.upcase()) do
          nil ->
            {:error, {:error_not_found, "Book not found"}}

          book ->
            {:ok, book}
        end

      false ->
        query =
          from b in Boom.Models.Books,
            # Simple regex for searching various books
            where: ilike(b.title, ^"#{id}%")

        stream = Boom.Repo.stream(query)

        # {:ok, [{book1}, {book2}]}
        case Boom.Repo.transaction(fn -> Enum.to_list(stream) end) do
          {_, []} -> {:error, {:error_not_found, "No books found"}}
          {_, list} -> {:ok, list}
        end
    end
  end
end
