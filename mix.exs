defmodule EventStore.Export.MixProject do
  use Mix.Project

  def project do
    [
      app: :eventstore_export,
      version: "0.1.0",
      elixir: "~> 1.5",
      escript: escript_config(),
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:csv, "~> 2.1"},
      {:eventstore, "~> 0.13"}
    ]
  end

  defp escript_config do
    [main_module: EventStore.Export.CLI]
  end
end
