defmodule EventStore.Export.CLI do
  def main([output_path]) do
    EventStore.Export.output(output_path)
  end

  def main(_args) do
    IO.puts """
    Usage: ./eventstore_export <output_path>
    """
  end
end
