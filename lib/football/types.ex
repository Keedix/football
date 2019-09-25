defmodule Football.Types do
  @moduledoc """
  Module exports custom data types
  """
  @typedoc """
  Represents data loaded from CSV. Every row is represented as a list of strings.

  Example list of symbolic names. The order does matter.
  ```
    [Index,League,Season,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HTHG,HTAG,HTR]
  ```

  """
  @type cvs_game_result :: [String.t()]

  @typedoc """
  ETS key representation as tuple pair of league and season.
  """
  @type ets_key :: {league :: String.t(), season :: String.t()}

  @typedoc """
  ETS representation of single row of data from CSV file. The key of ETS is created
  from tuple of league and season.
  """
  @type ets_game_result ::
          {
            key :: ets_key(),
            gameResultList :: [String.t()]
          }

  @typedoc """
  Map representation of CSV's row of data.
  """
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

  @type ets_table_name :: atom()

  @type league_season :: %{
          league: String.t(),
          season: String.t()
        }
end
