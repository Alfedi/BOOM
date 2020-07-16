defmodule BomasyWeb.Router do
  use BomasyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/books", BomasyWeb do
    pipe_through :api

    get("/:id", BookController, :get_book)
    post("/add_book", BookController, :add_book)
  end
end
