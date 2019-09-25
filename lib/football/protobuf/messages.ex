defmodule Football.Protobuf.Messages do
  @moduledoc """
  Module provides functions for managing proto structures
  """
  use Protobuf, from: Path.expand("../../../priv/proto-definitions/messages.proto", __DIR__)
end
