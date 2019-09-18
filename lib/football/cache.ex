defmodule Football.Cache do
  use GenServer
  require Logger

  alias Football.Utils.Ets

  @type state :: %{ets: atom()}

  @spec start_link(filePath :: String.t()) :: {:ok, pid()}
  def start_link(filePath) do
    GenServer.start_link(__MODULE__, filePath, name: __MODULE__)
  end

  @impl GenServer
  @spec init(filePath :: String.t()) :: {:ok, state()}
  def init(filePath) do
    table = Ets.create_football_table()

    :ok = load_csv_into_cache(filePath)

    {:ok, %{ets: table}}
  end

  @spec load_csv_into_cache(filePath :: String.t()) :: :ok
  defp load_csv_into_cache(filePath) do
    :ok =
      filePath
      |> File.stream!()
      |> CSV.decode()
      # First row describes columns names. It can be ommitted
      |> Enum.drop(1)
      |> Enum.each(fn {:ok, row} ->
        true = Ets.insert_game_result(row)
      end)
  end
end
