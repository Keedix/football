defmodule Football.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  @csv_file_name Application.get_env(:football, :csv_file)

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      FootballWeb.Endpoint,
      %{id: Football.Cache, start: {Football.Cache, :start_link, [@csv_file_name]}}
      # Starts a worker by calling: Football.Worker.start_link(arg)
      # {Football.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Football.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FootballWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
