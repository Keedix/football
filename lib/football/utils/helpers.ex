defmodule Football.Utils.Helpers do
  require Logger

  alias Football.Protobuf.Messages

  @type etsGameResult :: {index :: String.t(), gameResultList :: [String.t()]}
  @type game_result() :: %{
          String.t() => %{
            String.t() => String.t()
          }
        }

  @spec decode_ets_game_result_to_map(etsGameResult :: {String.t(), [String.t()]}) ::
          game_result()
  def decode_ets_game_result_to_map(etsGameResult) do
    [league, season, date, homeTeam, awayTeam, fthg, ftag, ftr, hthg, htag, htr] =
      etsGameResult
      |> decode_game_result

    decoded_season =
      season
      |> decode_season!()

    %{
      "#{league} #{decoded_season}" => %{
        "date" => date,
        "home_team" => homeTeam,
        "away_team" => awayTeam,
        "fthg" => fthg,
        "ftag" => ftag,
        "ftr" => ftr,
        "hthg" => hthg,
        "htag" => htag,
        "htr" => htr
      }
    }
  end

  @spec decode_ets_game_result_to_protobuf(etsGameResult :: {String.t(), [String.t()]}) ::
          %Messages.GameResultResponse{}
  def decode_ets_game_result_to_protobuf(etsGameResult) do
    [league, season, date, homeTeam, awayTeam, fthg, ftag, ftr, hthg, htag, htr] =
      etsGameResult
      |> decode_game_result()

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

  # -----------------------------------------------------
  # ----------------- PRIVATE FUNCTIONS -----------------
  # -----------------------------------------------------

  @spec decode_game_result(etsGameResult()) :: [String.t()]
  defp decode_game_result(etsGameResult) do
    {_index, result} = etsGameResult
    result
  end
end
