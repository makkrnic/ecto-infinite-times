use Mix.Config

config :infinite_times, InfiniteTimes.Repo,
  types: InfiniteTimes.PostgresTypes,
  adapter: Ecto.Adapters.Postgres,
  hostname: "localhost",
  port: 7777,
  database: "infinite_times_test",
  username: "inf_times",
  password: "inf_times",
  pool: Ecto.Adapters.SQL.Sandbox

config :infinite_times, ecto_repos: [InfiniteTimes.Repo]

config :logger, level: :debug
