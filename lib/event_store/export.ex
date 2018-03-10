defmodule EventStore.Export do
  @moduledoc """
  Export events stored in an [EventStore](https://hex.pm/packages/eventstore)
  database to disk.
  """

  @doc """
  Export the events from the EventStore configred in the given config file to
  the output path.

  ## Examples

      iex> EventStore.Export.output("path/to/output")
      :ok

  """
  def output(output_path) do
    File.mkdir_p!(output_path)

    serializer = Application.get_env(:eventstore, EventStore.Storage)[:serializer]

    EventStore.stream_all_forward()
    |> Stream.chunk_by(fn %EventStore.RecordedEvent{stream_uuid: stream_uuid} -> stream_uuid end)
    |> Stream.each(fn batch ->
      :ok = write_event_info(output_path, batch)
      :ok = write_events(output_path, serializer, batch)
    end)
    |> Stream.run()

    :ok
  end

  defp write_event_info(output_path, events) do
    [%EventStore.RecordedEvent{stream_uuid: stream_uuid} | _] = events

    filename = Path.join(output_path, "#{stream_uuid}.csv")
    file = File.open!(filename, [:write, :utf8])

    events
    |> Stream.map(&to_row/1)
    |> CSV.encode()
    |> Stream.each(&IO.write(file, &1))
    |> Stream.run()

    File.close(file)
  end

  defp write_events(output_path, serializer, events) do
    [%EventStore.RecordedEvent{stream_uuid: stream_uuid} | _] = events

    output_stream_path = Path.join(output_path, stream_uuid)

    File.mkdir_p!(output_stream_path)

    for event <- events do
      %EventStore.RecordedEvent{event_id: event_id, data: data, metadata: metadata} = event

      :ok = serialize_to_file(output_stream_path, "#{event_id}.data", serializer, data)
      :ok = serialize_to_file(output_stream_path, "#{event_id}.metadata", serializer, metadata)
    end

    :ok
  end

  defp serialize_to_file(path, filename, serializer, data) do
    filename = Path.join(path, filename)
    file = File.open!(filename, [:write])

    IO.binwrite(file, serializer.serialize(data))

    File.close(file)
  end

  defp to_row(%EventStore.RecordedEvent{} = event) do
    %EventStore.RecordedEvent{
      event_id: event_id,
      event_number: event_number,
      stream_uuid: stream_uuid,
      stream_version: stream_version,
      correlation_id: correlation_id,
      causation_id: causation_id,
      event_type: event_type,
      created_at: created_at
    } = event

    [
      event_id,
      event_number,
      stream_uuid,
      stream_version,
      correlation_id,
      causation_id,
      event_type,
      created_at
    ]
  end
end
