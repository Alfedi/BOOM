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
      from b in Boom.Models.Books,
        where: ilike(b.title, ^"#{title}%")

    stream = Boom.Repo.stream(query)

    # {:ok, [{book1}, {book2}]}
    Boom.Repo.transaction(fn -> Enum.to_list(stream) end)
  end

  # defp get_book_info(title) do
  #   case Books |> Boom.Repo.get_by(title: title) do
  #     nil ->
  #       {:error, {:error_not_found, "Book not found"}}

  #     book ->
  #       {:ok, book}
  #   end
  # end
end
