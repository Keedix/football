defmodule Football.Cache do
  use GenServer
  require Logger

  alias Football.Utils.Ets

  @type state :: %{ets: atom()}

  @spec start_link(fileName :: String.t()) :: {:ok, pid()}
  def start_link(fileName) do
    GenServer.start_link(__MODULE__, fileName, name: __MODULE__)
  end

  @impl GenServer
  @spec init(fileName :: String.t()) :: {:ok, state()}
  def init(fileName) do
    table = Ets.create_football_table()

    :ok = load_csv_into_cache(fileName)

    {:ok, %{ets: table}}
  end

  @spec load_csv_into_cache(fileName :: String.t()) :: :ok
  defp load_csv_into_cache(fileName) do
    :ok =
      "#{:code.priv_dir(:football)}/#{fileName}"
      |> File.stream!()
      |> CSV.decode()
      # First row describes columns names. It can be ommitted
      |> Enum.drop(1)
      |> Enum.each(fn {:ok, row} ->
        true = Ets.insert_game_result(row)
      end)
  end
end
