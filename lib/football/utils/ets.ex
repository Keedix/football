defmodule Football.Utils.Ets do
  require Ex2ms
  require Logger

  alias Football.Utils.Helpers

  @tableName :football_seasons

  @type table_name :: atom()
  @type game_result :: [String.t()]

  @doc """
  Creates ETS named table to store data from CSV file.
  """
  @spec create_football_table() :: table_name()
  def create_football_table() do
    Logger.info("Creating ETS table: #{@tableName}")
    @tableName = :ets.new(@tableName, [:set, :named_table])
  end

  @doc """
  Input of function is an CSV file's row represented as list of strings. The order does matter.
  Example:

  ```
     ["1", SP1", "201617", "19/08/2016", "La Coruna", "Eibar", "2", "1", "H", "0", "0", "D"]
  ```

  The fields keys are in order from left:
  ```
    Index,Div,Season,Date,HomeTeam,AwayTeam,FTHG,FTAG,FTR,HTHG,HTAG,HTR
  ```
  """
  @spec insert_game_result(game_result()) :: true
  def insert_game_result([index | rest_of_row]) do
    data = {index, rest_of_row}
    # Logger.debug(fn -> "Inserting game result: #{inspect(data)}" end)
    true = :ets.insert(@tableName, data)
  end

  @spec get_all_seasons_results(contentType :: String.t()) :: [
          {index :: String.t(), game_result()}
        ]
  def get_all_seasons_results(contentType) do
    matchSpec =
      Ex2ms.fun do
        row -> row
      end

    fun =
      case contentType do
        "application/json" ->
          &Helpers.decode_ets_game_result_to_map/1

        "application/vnd.google.protobuf" ->
          &Helpers.decode_ets_game_result_to_protobuf/1
      end

    @tableName
    |> :ets.select(matchSpec)
    |> Enum.map(fun)
  end
end
