defmodule BoomWeb.BookController do
  use BoomWeb, :controller

  require Logger

  alias BoomWeb.ErrorView
  alias BoomWeb.BookView
  alias BoomWeb.BooksView
  alias Boom.Book

  def add_book(conn, %{
        "ISBN" => id,
        "title" => title,
        "author" => author,
        "edition" => edition,
        "publisher" => publisher
      }) do
    case String.match?(
           id,
           ~r/((978[\--– ])?[0-9][0-9\--– ]{10}[\--– ][0-9xX])|((978)?[0-9]{9}[0-9Xx])/
         ) do
      true ->
        isbn = id |> String.replace(~r/(-| )/, "") |> String.upcase()

        case Book.add_book(isbn, title, author, publisher, edition) do
          {:ok, _} ->
            send_resp(conn, 201, "")

          {:error, {_, err_msg}} ->
            conn
            |> put_status(400)
            |> render(ErrorView, "400.json", %{err_msg: err_msg})
        end

      false ->
        conn
        |> put_status(400)
        |> render(ErrorView, "400.json", %{err_msg: "ISBN is not a valid number"})
    end
  end

  def get_book(conn, %{"id" => id}) do
    case Book.get_book(id) do
      {:ok, book} ->
        conn
        |> render(BookView, "book.json", %{book: book})
    end
  end

  def get_books(conn, params) do
    filters = parse_filters(params)
    limit = parse_limit(params["limit"])

    case Book.get_books(params["cursor"], filters, limit) do
      {:ok, book_list, cursors} ->
        conn |> render(BooksView, "books.json", %{book_list: book_list, cursors: cursors})
    end
  end

  def remove_book(conn, %{"id" => id}) do
    case Book.delete_book(id) do
      {:ok, _} ->
        send_resp(conn, 201, "")

      {:error, {_, err_msg}} ->
        conn
        |> put_status(400)
        |> render(ErrorView, "400.json", %{err_msg: err_msg})
    end
  end

  def edit_book(conn, %{
        "id" => id,
        "ISBN" => isbn,
        "title" => title,
        "author" => author,
        "edition" => edition,
        "publisher" => publisher
      }) do
    case Book.get_book(id) do
      {:ok, %{ISBN: _} = book} ->
        case Book.edit_book(book, isbn, title, author, edition, publisher) do
          {:ok, _} ->
            send_resp(conn, 201, "")

          {:error, {_, err_msg}} ->
            conn |> put_status(400) |> render(ErrorView, "400.json", %{err_msg: err_msg})
        end

      {:ok, %{}} ->
        conn
        |> put_status(404)
        |> render(ErrorView, "400.json", %{err_msg: "This book does not exist"})
    end
  end

  # Utils
  defp parse_filters(params),
    do:
      Map.take(params, ["title", "author", "publisher", "edition"])
      |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, String.to_atom(k), v) end)

  defp parse_limit(nil), do: nil

  defp parse_limit(limit) do
    case Integer.parse(limit) do
      :error -> nil
      {n, _} -> n
    end
  end
end
