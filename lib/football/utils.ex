defmodule Football.Utils do
  @moduledoc """
  Module contains functions for decoding and encoding to diffrent data formats.
  """
  require Logger

  alias Football.Protobuf.Messages
  alias Football.Types

  @spec decode_ets_game_result_to_map(Types.ets_game_result()) :: Types.game_result()
  def decode_ets_game_result_to_map(etsGameResult) do
    {{league, season}, [date, home_team, away_team, fthg, ftag, ftr, hthg, htag, htr]} =
      etsGameResult

    decoded_season =
      season
      |> decode_season!()

    %{
      league: league,
      season: decoded_season,
      date: date,
      home_team: home_team,
      away_team: away_team,
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
    {{league, season}, [date, home_team, away_team, fthg, ftag, ftr, hthg, htag, htr]} =
      etsGameResult

    decoded_season =
      season
      |> decode_season!()

    Messages.GameResult.new(
      league: league,
      season: decoded_season,
      date: date,
      homeTeam: home_team,
      awayTeam: away_team,
      fthg: fthg,
      ftag: ftag,
      ftr: ftr,
      hthg: hthg,
      htag: htag,
      htr: htr
    )
  end

  @doc """
  Transforms CSV value representation to map with 2 keys: `league`, `season`

  ## Example
    iex(1)> Football.Utils.decode_ets_league_season_to_map({"SP1", "201516"})
    %{league: "SP1", season: "2015-2016"}
  """
  @spec decode_ets_league_season_to_map(Types.ets_key()) :: Types.league_season()
  def decode_ets_league_season_to_map({league, season}) do
    decoded_season =
      season
      |> decode_season!()

    %{
      league: league,
      season: decoded_season
    }
  end

  @doc """
  Transforms CSV value representation to protobuf structure

  ## Example
    iex(2)> Football.Utils.decode_ets_league_season_to_protobuf({"SP1", "201516"})
    %Football.Protobuf.Messages.LeagueSeason{league: "SP1", season: "2015-2016"}
  """
  @spec decode_ets_league_season_to_protobuf(Types.ets_key()) :: %Messages.LeagueSeason{}
  def decode_ets_league_season_to_protobuf({league, season}) do
    decoded_season =
      season
      |> decode_season!()

    Messages.LeagueSeason.new(league: league, season: decoded_season)
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
  defp decode_season!(encoded_season) do
    case String.length(encoded_season) do
      6 ->
        {first_year, second_year} = encoded_season |> String.split_at(4)
        {f, _s} = first_year |> String.split_at(2)

        "#{first_year}-#{f}#{second_year}"

      length ->
        throw(
          "Bad Season years format. Expected 6 long characters string, got #{length}  characters long: #{
            encoded_season
          }"
        )
    end
  end

  @doc """
  Transform season to CSV's value format.

  ## Examples

    iex> Football.Utils.encode_season!("2015-2016")
    "201516"

  """
  @spec encode_season!(decoded_season :: String.t()) :: String.t()
  def encode_season!(decoded_season) do
    [first, second] = String.split(decoded_season, "-")
    {_, s} = String.split_at(second, 2)
    "#{first}#{s}"
  end
end
