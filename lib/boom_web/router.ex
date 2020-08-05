defmodule BoomWeb.Router do
  use BoomWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/books", BoomWeb do
    pipe_through :api

    get("/:id", BookController, :get_book)
    post("/add_book", BookController, :add_book)
  end
end
