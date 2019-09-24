use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :football, FootballWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :football,
  csv_file: "football_seasons_data_test.csv",
  ets_table_name: :football_seasons_test
