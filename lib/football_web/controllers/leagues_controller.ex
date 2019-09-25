defmodule FootballWeb.LeaguesController do
  use FootballWeb, :controller

  alias Football.{Utils.Ets, Protobuf.Messages}
  alias FootballWeb.Utils

  def get_all_leagues(conn, _params) do
    case get_req_header(conn, "accept") do
      [content_type] = ["application/vnd.google.protobuf"] ->
        protobuf_leagues_seasons =
          Ets.get_league_season_list()
          |> Enum.map(&Football.Utils.decode_ets_league_season_to_protobuf/1)

        encoded_protobuf_body =
          Messages.LeaguesSeasons.new(leaguesSeasons: protobuf_leagues_seasons, statusCode: 200)
          |> Messages.LeaguesSeasons.encode()

        conn
        |> put_resp_content_type(content_type)
        |> send_resp(200, encoded_protobuf_body)

      _ ->
        content_type = "application/json"

        json_leagues_seasons =
          Ets.get_league_season_list()
          |> Enum.map(&Football.Utils.decode_ets_league_season_to_map/1)

        conn
        |> put_resp_content_type(content_type)
        |> put_status(200)
        |> json(Utils.resp(%{leagues_seasons: json_leagues_seasons}))
    end
  end

  def get_league_season_results(conn, %{"league" => league, "season" => season} = params) do
    ets_game_results = Ets.get_league_season_result(league, season)

    accept = get_req_header(conn, "accept")

    {content_type, {status_code, body}} =
      if accept == ["application/vnd.google.protobuf"] do
        {accept, get_league_season_proto_results(ets_game_results, params)}
      else
        {"application/json", get_league_season_json_results(ets_game_results, params)}
      end

    conn
    |> put_resp_content_type(content_type)
    |> send_resp(status_code, body)
  end

  defp get_league_season_proto_results(ets_game_result, %{"league" => league, "season" => season}) do
    {status_code, body} =
      case ets_game_result do
        [] ->
          data =
            Messages.GameResults.new(
              statusCode: 404,
              message: "League '#{league}' in season '#{season}' wasn't found"
            )

          {404, data}

        game_results ->
          proto_games_results =
            game_results |> Enum.map(&Football.Utils.decode_ets_game_result_to_protobuf/1)

          data =
            Messages.GameResults.new(
              statusCode: 200,
              gameResults: proto_games_results
            )

          {200, data}
      end

    {status_code, Messages.GameResults.encode(body)}
  end

  defp get_league_season_json_results(ets_game_results, %{"league" => league, "season" => season}) do
    {status_code, body} =
      case ets_game_results do
        [] ->
          {404, Utils.error_resp("League '#{league}' in season '#{season}' wasn't found", 404)}

        game_results ->
          decoded_game_results =
            game_results
            |> Enum.map(&Football.Utils.decode_ets_game_result_to_map/1)

          {200, Utils.resp(%{game_results: decoded_game_results})}
      end

    {status_code, Jason.encode!(body)}
  end
end
