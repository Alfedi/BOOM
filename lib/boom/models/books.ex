defmodule Boom.Models.Books do
  use Ecto.Schema

  schema "books" do
    field :ISBN, :string
    field :title, :string
    field :author, :string
    field :edition, :string
    field :publisher, :string
    field :is_borrowed, :boolean, default: false
    field :borrowed_by, :string

    timestamps()
  end

  def changeset(book, params \\ %{}) do
    book
    |> Ecto.Changeset.cast(params, [:book])
  end

  def insert_book(book) do
    case Boom.Repo.insert(book) do
      {:ok, _} = res_ok -> res_ok
      _ -> {:error, {:something_went_wrong, "Could not insert book"}}
    end
  end

  def remove_book(isbn) do
    case Boom.Repo.delete(isbn) do
      {:ok, _} = res_ok -> res_ok
      _ -> {:error, {:something_went_wrong, "Could not remove book"}}
    end
  end
end
