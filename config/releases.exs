import Config

config :football, FootballWeb.Endpoint,
  http: [:inet6, port: String.to_integer(System.fetch_env!("PORT"))]
