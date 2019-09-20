defmodule FootballWeb.Utils do
  @moduledoc """
  Functions to enforce same style of JSON API responses based on https://stackoverflow.com/a/23708903
  """
  @type error_resp :: %{error: %{code: integer(), message: String.t()}}
  @type resp() :: %{data: map()}

  @doc """
  Returns error response formatted map.

  ## Examples

  iex(1)> FootballWeb.Utils.error_resp("Test error message", 404)
  %{error: %{code: 404, message: "Test error message"}}

  """
  @spec error_resp(message :: String.t(), code :: integer()) :: error_resp()
  def error_resp(message, code) do
    %{
      error: %{
        code: code,
        message: message
      }
    }
  end

  @doc """
  Returns success response formatted map. Excepts map as input.

  ## Examples

  iex(1)> FootballWeb.Utils.resp(%{test: "some value"})
  %{data: %{test: "some value"}}

  """
  @spec resp(data :: map()) :: resp()
  def resp(data) when is_map(data) do
    %{
      data: data
    }
  end
end
