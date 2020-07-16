defmodule BomasyWeb.BookController do
  use BomasyWeb, :controller

  require Logger

  alias BomasyWeb.ErrorView
  alias BomasyWeb.BookView
  alias Bomasy.Book

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

  def get_book(conn, %{"id" => id}) do
    # Need a better way to guess if it's a ISBN or a title
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

      false ->
        case Book.get_book(Kernel.to_string(id)) do
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

  # def get_book(conn, %{"title" => title}) do
  #   case Book.get_book(title) do
  #     {:ok, book} ->
  #       conn
  #       |> render(BookView, "book.json", %{book: book})

  #     {:error, {_, err_msg}} ->
  #       conn
  #       |> put_status(404)
  #       |> render(ErrorView, "404.json", %{err_msg: err_msg})
  #   end
  # end
end
