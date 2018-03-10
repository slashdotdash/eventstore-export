use Mix.Config

config :eventstore, EventStore.Storage,
  serializer: EventStore.TermSerializer,
  username: "postgres",
  password: "postgres",
  database: "eventstore_export",
  hostname: "localhost",
  pool_size: 1
