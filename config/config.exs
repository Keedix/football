# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :football, FootballWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "V3WChtRDT12p3EkGi1hi8AK9yOrHBndl/R7lQbHqBhq9PivG1HTmTlS2TFhs4kNH",
  render_errors: [view: FootballWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Football.PubSub, adapter: Phoenix.PubSub.PG2]

# Custom application configuration
config :football,
  csv_file: "football_seasons_data.csv",
  ets_table_name: :football_seasons

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :mime, :types, %{
  "application/vnd.google.protobuf" => ["protobuf"]
}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
