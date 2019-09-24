defmodule FootballWeb.LeaguesControllerTest do
  use FootballWeb.ConnCase
  @league "SP1"
  @decodedSeason "2016-2017"

  test "GET /api/1.0/leagues application/json", %{conn: conn} do
    conn = get(conn, "/api/1.0/leagues")
    body = json_response(conn, 200)

    assert body == %{
             "data" => %{
               "leagues_seasons" => [%{"league" => "SP1", "season" => "2016-2017"}]
             }
           }
  end

  test "GET /api/1.0/leagues application/vnd.google.protobuf", %{conn: conn} do
    new_conn =
      conn
      |> put_req_header("accept", "application/vnd.google.protobuf")
      |> get("/api/1.0/leagues")

    leagueSeason =
      Football.Protobuf.Messages.LeagueSeason.new(league: @league, season: @decodedSeason)

    expected =
      Football.Protobuf.Messages.LeaguesSeasons.new(
        leaguesSeasons: [leagueSeason],
        statusCode: 200
      )
      |> Football.Protobuf.Messages.LeaguesSeasons.encode()

    assert response(new_conn, 200) == expected
  end

  test "GET /api/1.0/leagues/:league/seasons/:season", %{conn: conn} do
    conn = get(conn, "/api/1.0/leagues/SP1/seasons/2016-2017")
    body = json_response(conn, 200)

    assert body == %{
             "data" => %{
               "game_results" => [
                 %{
                   "league" => "SP1",
                   "season" => "2016-2017",
                   "away_team" => "Eibar",
                   "date" => "19/08/2016",
                   "ftag" => "1",
                   "fthg" => "2",
                   "ftr" => "H",
                   "home_team" => "La Coruna",
                   "htag" => "0",
                   "hthg" => "0",
                   "htr" => "D"
                 },
                 %{
                   "away_team" => "Osasuna",
                   "date" => "19/08/2016",
                   "ftag" => "1",
                   "fthg" => "1",
                   "ftr" => "D",
                   "home_team" => "Malaga",
                   "htag" => "0",
                   "hthg" => "0",
                   "htr" => "D",
                   "league" => "SP1",
                   "season" => "2016-2017"
                 }
               ]
             }
           }
  end

  test "GET /api/1.0/leagues/:league/seasons/:season - 404", %{conn: conn} do
    conn = get(conn, "/api/1.0/leagues/SP1/seasons/2019-2020")
    body = json_response(conn, 404)

    assert body == %{
             "error" => %{
               "code" => 404,
               "message" => "League 'SP1' in season '2019-2020' wasn't found"
             }
           }
  end
end
