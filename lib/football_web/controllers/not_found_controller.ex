defmodule FootballWeb.NotFoundController do
  use FootballWeb, :controller

  def not_found(conn, _params) do
    conn
    |> put_status(404)
    |> json(FootballWeb.Utils.error_resp("Not found", 404))
  end
end
