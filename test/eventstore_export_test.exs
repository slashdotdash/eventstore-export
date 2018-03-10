defmodule EventStore.ExportTest do
  use ExUnit.Case
  doctest EventStore.Export

  test "greets the world" do
    assert EventStore.Export.hello() == :world
  end
end
