# EventStore export

Export events stored in an [EventStore](https://hex.pm/packages/eventstore) database to disk.

## Installation

Add `eventstore_export` to deps in `mix.exs`:

```elixir
defp deps
  [
    {:eventstore_export, github: "slashdotdash/eventstore-export"}
  ]
end
```

Fetch dependencies and compile:

```console
mix do deps.get, compile
```

## Usage

Output all events, including serialized event data and metadata as individual files:

```console
mix eventstore.export <output_path>
```

Output events, but not the event data nor metadata:

```console
mix eventstore.export <output_path> --no-data --no-metadata
```
