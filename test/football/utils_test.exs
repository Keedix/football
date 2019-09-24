defmodule Football.UtilsTest do
  use ExUnit.Case, async: true
  @league "league"
  @season "201516"
  @date "19/08/2016"
  @homeTeam "La Coruna"
  @awayTeam "Eibar"
  @fthg "2"
  @ftag "1"
  @ftr "H"
  @hthg "0"
  @htag "0"
  @htr "D"
  @decoded_season "2015-2016"

  @etsGameResult {{@league, @season},
                  [@date, @homeTeam, @awayTeam, @fthg, @ftag, @ftr, @hthg, @htag, @htr]}
  test "should decode ets game result to map" do
    result = Football.Utils.decode_ets_game_result_to_map(@etsGameResult)

    assert result ==
             %{
               league: @league,
               season: @decoded_season,
               date: @date,
               home_team: @homeTeam,
               away_team: @awayTeam,
               fthg: @fthg,
               ftag: @ftag,
               ftr: @ftr,
               hthg: @hthg,
               htag: @htag,
               htr: @htr
             }
  end

  test "should decode ets league seasons to map" do
    result = Football.Utils.decode_ets_league_season_to_map({@league, @season})
    assert result == %{league: @league, season: @decoded_season}
  end

  test "should decode ets game result to protobuf" do
    result = Football.Utils.decode_ets_game_result_to_protobuf(@etsGameResult)
    assert result.league == @league
    assert result.season == @decoded_season
    assert result.date == @date
    assert result.homeTeam == @homeTeam
    assert result.awayTeam == @awayTeam
    assert result.fthg == @fthg
    assert result.ftag == @ftag
    assert result.ftr == @ftr
    assert result.hthg == @hthg
    assert result.htag == @htag
    assert result.htr == @htr
  end

  test "should decode ets league seasons to protobuf" do
    result = Football.Utils.decode_ets_league_season_to_protobuf({@league, @season})
    assert result.league == @league
    assert result.season == @decoded_season
  end
end
