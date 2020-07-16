defmodule Bomasy.Repo do
  use Ecto.Repo,
    otp_app: :bomasy,
    adapter: Ecto.Adapters.Postgres
end
