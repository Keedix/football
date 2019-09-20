defmodule FootballWeb.Router do
  use FootballWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json", "protobuf"]
  end

  scope "/", FootballWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api/1.0", FootballWeb do
    pipe_through :api

    get "/leagues", LeaguesController, :get_all_leagues
    get "/leagues/:league/season/:season", LeaguesController, :get_league_season_results
  end
end
