# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :boom,
  ecto_repos: [Boom.Repo]

config :boom, Boom.Repo,
  hostname: System.get_env("POSTGRESQL_HOST"),
  username: System.get_env("POSTGRESQL_USERNAME"),
  password: System.get_env("POSTGRESQL_PASSWORD"),
  database: System.get_env("POSTGRESQL_DATABASE"),
  port: System.get_env("POSTGRESQL_PORT") || 5432,
  pool_size: 10

# Configures the endpoint
config :boom, BoomWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LL8dbpuptbUGutCwPr8DFYjpRPf6Aw7y+jEw51Qj2ceI9T2DinZwtVUfWspO/boB",
  render_errors: [view: BoomWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Boom.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "v9h236Qy"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
