defmodule Football.Utils.Ets do
  require Ex2ms
  require Logger

  alias Football.Types

  @tableName Application.get_env(:football, :ets_table_name)

  @doc """
  Creates ETS named table to store data from CSV file.
  """
  @spec create_football_table() :: Types.ets_table_name()
  def create_football_table() do
    Logger.info("Creating ETS table: #{@tableName}")
    @tableName = :ets.new(@tableName, [:bag, :named_table])
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

    leagueUpperCase =
      league
      |> String.upcase()

    data = {{leagueUpperCase, season}, tail}

    Logger.debug(fn ->
      "ETS: inserting data: #{inspect(data)}"
    end)

    true = :ets.insert(@tableName, data)
  end

  @spec get_league_season_list() :: [Types.ets_key()]
  def get_league_season_list() do
    matchSpec =
      Ex2ms.fun do
        {key, _rest} -> key
      end

    result =
      @tableName
      |> :ets.select(matchSpec)
      |> Enum.uniq()

    Logger.debug(fn ->
      "ETS: League season list: #{inspect(result)}"
    end)

    result
  end

  @spec get_league_season_result(String.t(), String.t()) :: [Types.ets_game_result()]
  def get_league_season_result(league, season) do
    upperCaseLeague = String.upcase(league)
    etsEncodedSeason = Football.Utils.encode_season!(season)

    result = :ets.lookup(@tableName, {upperCaseLeague, etsEncodedSeason})

    Logger.debug(fn ->
      "ETS: Result of getting league: #{league}, season: #{season}, #{inspect(result)}"
    end)

    result
  end
end
