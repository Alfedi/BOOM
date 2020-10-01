defmodule BoomWeb.BookController do
  use BoomWeb, :controller

  require Logger

  alias BoomWeb.ErrorView
  alias BoomWeb.BookView
  alias BoomWeb.BooksView
  alias Boom.Book

  def add_book(conn, %{
        "ISBN" => isbn,
        "title" => title,
        "author" => author,
        "edition" => edition,
        "publisher" => publisher
      }) do
    case String.match?(Kernel.to_string(isbn), ~r/^(97(8|9))?\d{9}(\d|X)$/) do
      true ->
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

  # Need a better way to guess if it's a ISBN or a title
  def get_book(conn, %{"id" => id}) do
    # ISBN
    case String.match?(Kernel.to_string(id), ~r/^(97(8|9))?\d{9}(\d|X)$/) do
      true ->
        case Book.get_book(String.to_integer(id)) do
          {:ok, book} ->
            conn
            |> render(BookView, "book.json", %{book: book})

          {:error, {_, err_msg}} ->
            conn
            |> put_status(404)
            |> render(ErrorView, "404.json", %{err_msg: err_msg})
        end

      # title
      false ->
        case Book.get_book(Kernel.to_string(id)) do
          {:ok, book_list} ->
            conn
            |> render(BooksView, "books.json", %{book_list: book_list})

          {:error, {_, err_msg}} ->
            conn
            |> put_status(404)
            |> render(ErrorView, "404.json", %{err_msg: err_msg})
        end
    end
  end

  def get_books(conn, params) do
    Logger.debug("params: #{inspect(params)}")
    limit = parse_limit(params["limit"])

    case Book.get_books(params["cursor"], limit) do
      {:ok, book_list, cursors} ->
        conn |> render(BooksView, "books.json", %{book_list: book_list, cursors: cursors})

      {:error, err_msg} ->
        conn |> put_status(500) |> render(ErrorView, "500.json", %{err_msg: err_msg})
    end
  end

  # Utils
  defp parse_limit(nil), do: nil

  defp parse_limit(limit) do
    case Integer.parse(limit) do
      :error -> nil
      {n, _} -> n
    end
  end
end
