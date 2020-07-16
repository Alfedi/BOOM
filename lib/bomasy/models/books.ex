defmodule Bomasy.Models.Books do
  use Ecto.Schema

  schema "books" do
    field :ISBN, :integer
    field :title, :string
    field :author, :string
    field :edition, :integer
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
    case Bomasy.Repo.insert(book) do
      {:ok, _} = res_ok -> res_ok
      _ -> {:error, {:something_went_wrong, "Could not insert book"}}
    end
  end
end
