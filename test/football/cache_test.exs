defmodule Football.CacheTest do
  use ExUnit.Case, async: true
  @tableName Application.get_env(:football, :ets_table_name)

  test "should load CSV file into ETS" do
    pid = Process.whereis(Football.Cache)
    assert :sys.get_state(pid) == %{ets: @tableName}
  end
end
