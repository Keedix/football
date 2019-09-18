defmodule FootballWeb.LeaguesController do
  use FootballWeb, :controller

  alias Football.{Utils.Ets, Protobuf.Messages}

  def get_all_leagues(conn, _params) do
    case get_req_header(conn, "accept") do
      [contentType] = ["application/vnd.google.protobuf"] ->
        protobufGameResults =
          contentType
          |> Ets.get_all_seasons_results()

        encodedProtobufBody =
          Messages.GameResultsResponse.new(gameResults: protobufGameResults)
          |> Messages.GameResultsResponse.encode()

        conn
        |> put_resp_content_type(contentType)
        |> send_resp(200, encodedProtobufBody)

      _ ->
        jsonGameResults =
          "application/json"
          |> Ets.get_all_seasons_results()

        conn
        |> json(jsonGameResults)
    end
  end

  def get_league_season_record(conn, _params) do
    IO.inspect(conn)

    conn
    |> send_resp()
  end
end
