defmodule Football.Utils.Helpers do
  require Logger

  alias Football.Protobuf.Messages

  @type ets_game_result ::
          {{league :: String.t(), season :: String.t()}, gameResultList :: [String.t()]}
  @type game_result() :: %{
          league: String.t(),
          season: String.t(),
          date: String.t(),
          home_team: String.t(),
          away_team: String.t(),
          fthg: String.t(),
          ftag: String.t(),
          ftr: String.t(),
          hthg: String.t(),
          htag: String.t(),
          htr: String.t()
        }

  @spec decode_ets_game_result_to_map(ets_game_result()) :: game_result()
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

  @spec decode_ets_game_result_to_protobuf(ets_game_result()) :: %Messages.GameResultResponse{}
  def decode_ets_game_result_to_protobuf(etsGameResult) do
    {{league, season}, [date, homeTeam, awayTeam, fthg, ftag, ftr, hthg, htag, htr]} =
      etsGameResult

    Messages.GameResultResponse.new(
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

  @doc """
  Example input:
  ```
    "201617"
  ```
  Example output:
  ```
    "2016-2017"
  ```

  """
  @spec decode_season!(String.t()) :: String.t()
  def decode_season!(encodedSeason) do
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
