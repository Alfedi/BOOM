defmodule BoomWeb.BookController do
  use BoomWeb, :controller

  require Logger

  alias BoomWeb.ErrorView
  alias BoomWeb.BookView
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
        isbn = id |> String.replace("-", "") |> String.upcase()

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

      {:error, {_, err_msg}} ->
        conn
        |> put_status(404)
        |> render(ErrorView, "404.json", %{err_msg: err_msg})
    end
  end
end
