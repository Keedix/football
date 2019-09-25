defmodule FootballWeb.NotFoundControllerTest do
  use FootballWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/api/1.0/leagues/seasons")
    assert json_response(conn, 404) == %{"error" => %{"code" => 404, "message" => "Not found"}}
  end
end
