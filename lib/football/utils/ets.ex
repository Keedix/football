defmodule Football.Utils.Ets do
  @moduledoc """
  Module provides wrappers around common requests to ETS
  """
  require Ex2ms
  require Logger

  alias Football.Types

  @table_name Application.get_env(:football, :ets_table_name)

  @doc """
  Creates ETS named table to store data from CSV file.
  """
  @spec create_football_table() :: Types.ets_table_name()
  def create_football_table() do
    Logger.info("Creating ETS table: #{@table_name}")
    @table_name = :ets.new(@table_name, [:bag, :named_table])
  end

  @doc """
  Input of function is an CSV file's row represented as list of strings. The order does matter.
  Example:

  ```
     ["1", SP1", "201617", "19/08/2016", "La Coruna", "Eibar", "2", "1", "H", "0", "0", "D"]
  ```

  The fields keys are in order from left:
  ```
    Index,League,Season,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HTHG,HTAG,HTR
  ```

  The explanations of keys:
  ```
    Div = League Division
    Date = Match Date (dd/mm/yy)
    Time = Time of match kick off
    HomeTeam = Home Team
    AwayTeam = Away Team
    FTHG and HG = Full Time Home Team Goals
    FTAG and AG = Full Time Away Team Goals
    FTR and Res = Full Time Result (H=Home Win, D=Draw, A=Away Win)
    HTHG = Half Time Home Team Goals
    HTAG = Half Time Away Team Goals
    HTR = Half Time Result (H=Home Win, D=Draw, A=Away Win)
  ```
  """
  @spec insert_game_result(Types.cvs_game_result()) :: true
  def insert_game_result(game_result) do
    [_index, league, season | tail] = game_result

    upcase_league =
      league
      |> String.upcase()

    data = {{upcase_league, season}, tail}

    Logger.debug(fn ->
      "ETS: inserting data: #{inspect(data)}"
    end)

    true = :ets.insert(@table_name, data)
  end

  @spec get_league_season_list() :: [Types.ets_key()]
  def get_league_season_list() do
    match_spec =
      Ex2ms.fun do
        {key, _rest} -> key
      end

    result =
      @table_name
      |> :ets.select(match_spec)
      |> Enum.uniq()

    Logger.debug(fn ->
      "ETS: League season list: #{inspect(result)}"
    end)

    result
  end

  @spec get_league_season_result(String.t(), String.t()) :: [Types.ets_game_result()]
  def get_league_season_result(league, season) do
    upcase_league = String.upcase(league)
    ets_encoded_season = Football.Utils.encode_season!(season)

    result = :ets.lookup(@table_name, {upcase_league, ets_encoded_season})

    Logger.debug(fn ->
      "ETS: Result of getting league: #{league}, season: #{season}, #{inspect(result)}"
    end)

    result
  end
end
