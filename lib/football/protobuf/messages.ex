defmodule Football.Protobuf.Messages do
  use Protobuf, from: Path.expand("../../../priv/proto/messages.proto", __DIR__)
end
