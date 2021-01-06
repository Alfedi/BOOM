defmodule BoomWeb.Router do
  use BoomWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api/books", BoomWeb do
    pipe_through(:api)

    post("/", BookController, :add_book)
    get("/", BookController, :get_books)
    get("/:id", BookController, :get_book)
    delete("/:id", BookController, :remove_book)
  end
end
