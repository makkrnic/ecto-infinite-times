defmodule InfiniteTimes.MixProject do
  use Mix.Project

  def project do
    [
      app: :infinite_times,
      version: "0.0.2-dev",
      elixir: "~> 1.4",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      preferred_cli_env: [espec: :test],
      test_coverage: [tool: Coverex.Task],
      description: description(),
      package: package(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:logger, :ecto, :postgrex],
      #mod: {InfiniteTimes, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 2.1"},
      {:postgrex, ">= 0.0.0"},
      {:credo, "~> 0.9.0-rc6", only: [:dev, :test], runtime: false},

      # Tests
      {:espec, "~> 1.5.0", only: :test},
      {:coverex, "~> 1.4.10", only: :test},

      # Docs
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}
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
      links: %{"GitHub" => "https://github.com/makkrnic/ecto-infinite-times"},
    ]
  end
end
