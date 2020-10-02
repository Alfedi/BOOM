defmodule Boom.Repo do
  use Ecto.Repo,
    otp_app: :boom,
    adapter: Ecto.Adapters.Postgres

  use Paginator
end
