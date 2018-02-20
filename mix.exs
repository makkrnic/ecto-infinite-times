defmodule InfiniteTimes.MixProject do
  use Mix.Project

  def project do
    [
      app: :infinite_times,
      version: "0.1.0",
      elixir: "~> 1.4",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [espec: :test],
      test_coverage: [tool: Coverex.Task]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:logger, :ecto, :postgrex],
      mod: {InfiniteTimes, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 2.1"},
      {:postgrex, "~> 0.13"},
      {:credo, "~> 0.9.0-rc1", only: [:dev, :test], runtime: false},

      # Tests
      {:espec, "~> 1.5.0", only: :test},
      {:coverex, "~> 1.4.10", only: :test},

      # Docs
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}
    ]
  end
end
