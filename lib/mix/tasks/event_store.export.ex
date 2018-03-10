defmodule Mix.Tasks.EventStore.Export do
  @moduledoc """
  Export events stored in an EventStore database to disk.

  ## Examples

      mix event_store.export <output_path>

  ## Command line options

    * `--quiet` - do not log output

  """

  use Mix.Task

  @shortdoc "Export events stored in an EventStore database to disk"

  @doc false
  def run([]) do
    Mix.raise("Usage: mix event_store.export <output_path>")
  end

  def run(args) do
    {opts, [output_path], _} = OptionParser.parse(args, switches: [quiet: :boolean])

    {:ok, _} = Application.ensure_all_started(:eventstore)

    case EventStore.Export.output(output_path) do
      :ok ->
        unless opts[:quiet] do
          Mix.shell().info("The EventStore database has been exported to: #{output_path}")
        end

      {:error, error} ->
        Mix.raise("The EventStore database couldn't be exported, reason given: #{inspect(error)}")
    end

    Mix.Task.reenable("event_store.export")
  end
end
