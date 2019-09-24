defmodule Football.Utils do
  require Logger

  alias Football.Protobuf.Messages
  alias Football.Types

  @spec decode_ets_game_result_to_map(Types.ets_game_result()) :: Types.game_result()
  def decode_ets_game_result_to_map(etsGameResult) do
    {{league, season}, [date, homeTeam, awayTeam, fthg, ftag, ftr, hthg, htag, htr]} =
      etsGameResult

    decoded_season =
      season
      |> decode_season!()

    %{
      league: league,
      season: decoded_season,
      date: date,
      home_team: homeTeam,
      away_team: awayTeam,
      fthg: fthg,
      ftag: ftag,
      ftr: ftr,
      hthg: hthg,
      htag: htag,
      htr: htr
    }
  end

  @spec decode_ets_game_result_to_protobuf(Types.ets_game_result()) ::
          %Messages.GameResult{}
  def decode_ets_game_result_to_protobuf(etsGameResult) do
    {{league, season}, [date, homeTeam, awayTeam, fthg, ftag, ftr, hthg, htag, htr]} =
      etsGameResult

    Messages.GameResult.new(
      league: league,
      season: season,
      date: date,
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      fthg: fthg,
      ftag: ftag,
      ftr: ftr,
      hthg: hthg,
      htag: htag,
      htr: htr
    )
  end

  @spec decode_ets_league_season_to_map(Types.ets_key()) :: Types.league_season()
  def decode_ets_league_season_to_map({league, season}) do
    %{
      league: league,
      season: season
    }
  end

  @spec decode_ets_league_season_to_protobuf(Types.ets_key()) :: %Messages.LeagueSeason{}
  def decode_ets_league_season_to_protobuf({league, season}) do
    Messages.LeagueSeason.new(league: league, season: season)
  end

  # Example input:
  # ```
  #   "201617"
  # ```
  # Example output:
  # ```
  #   "2016-2017"
  # ```
  @spec decode_season!(String.t()) :: String.t()
  defp decode_season!(encodedSeason) do
    case String.length(encodedSeason) do
      6 ->
        {firstYear, secondYear} = encodedSeason |> String.split_at(4)
        {f, _s} = firstYear |> String.split_at(2)

        "#{firstYear}-#{f}#{secondYear}"

      length ->
        throw(
          "Bad Season years format. Expected 6 long characters string, got #{length}  characters long: #{
            encodedSeason
          }"
        )
    end
  end
end
