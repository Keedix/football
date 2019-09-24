defmodule FootballWeb.LeaguesController do
  use FootballWeb, :controller

  alias Football.{Utils.Ets, Protobuf.Messages}
  alias FootballWeb.Utils

  def get_all_leagues(conn, _params) do
    case get_req_header(conn, "accept") do
      [contentType] = ["application/vnd.google.protobuf"] ->
        protobufLeaguesSeasons =
          Ets.get_league_season_list()
          |> Enum.map(&Football.Utils.decode_ets_league_season_to_protobuf/1)

        encodedProtobufBody =
          Messages.LeaguesSeasons.new(leaguesSeasons: protobufLeaguesSeasons, statusCode: 200)
          |> Messages.LeaguesSeasons.encode()

        conn
        |> put_resp_content_type(contentType)
        |> send_resp(200, encodedProtobufBody)

      _ ->
        contentType = "application/json"

        jsonLeaguesSeasons =
          Ets.get_league_season_list()
          |> Enum.map(&Football.Utils.decode_ets_league_season_to_map/1)

        conn
        |> put_resp_content_type(contentType)
        |> put_status(200)
        |> json(Utils.resp(%{leagues_seasons: jsonLeaguesSeasons}))
    end
  end

  def get_league_season_results(conn, %{"league" => league, "season" => season}) do
    etsGameResults = Ets.get_league_season_result(league, season)

    case get_req_header(conn, "accept") do
      [contentType] = ["application/vnd.google.protobuf"] ->
        {statusCode, encodedProtobufBody} =
          case etsGameResults do
            [] ->
              data =
                Messages.GameResults.new(
                  statusCode: 404,
                  message: "League '#{league}' in season '#{season}' wasn't found"
                )

              {404, data}

            gameResults ->
              protoGameResults =
                gameResults |> Enum.map(&Football.Utils.decode_ets_game_result_to_protobuf/1)

              data =
                Messages.GameResults.new(
                  statusCode: 200,
                  gameResults: protoGameResults
                )

              {200, data}
          end

        conn
        |> put_resp_content_type(contentType)
        |> send_resp(statusCode, encodedProtobufBody |> Messages.GameResults.encode())

      _ ->
        {statusCode, data} =
          case etsGameResults do
            [] ->
              {404,
               Utils.error_resp("League '#{league}' in season '#{season}' wasn't found", 404)}

            gameResults ->
              decodedGameResults =
                gameResults
                |> Enum.map(&Football.Utils.decode_ets_game_result_to_map/1)

              {200, Utils.resp(%{game_results: decodedGameResults})}
          end

        conn
        |> put_status(statusCode)
        |> json(data)
    end
  end
end
