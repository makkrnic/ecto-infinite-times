defmodule InfiniteTimes.MixProject do
  use Mix.Project

  @version "0.3.1"

  def project do
    [
      app: :infinite_times,
      version: @version,
      elixir: "~> 1.10",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [espec: :test],
      test_coverage: [tool: Coverex.Task],
      description: description(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:logger, :ecto_sql, :postgrex]
    ]
  end

  defp elixirc_paths(:test) do
    ["lib", "spec/support"]
  end

  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.15.0"},
      {:credo, "~> 0.9.0-rc6", only: :dev, runtime: false},

      # Tests
      {:espec, "~> 1.8.0", only: :test},
      {:coverex, "~> 1.4.10", only: :test},

      # Docs
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Ecto and postgrex support for infinite dates and times.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE*"],
      maintainers: ["Mak Krnic"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/makkrnic/ecto-infinite-times"}
    ]
  end

  defp docs do
    [
      main: "InfiniteTimes",
      canonical: "https://hexdocs.pm/infinite_times",
      source_url: "https://github.com/makkrnic/ecto-infinite-times"
    ]
  end
end
