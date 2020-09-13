defmodule InfiniteTimes.Repo do
  use Ecto.Repo,
    otp_app: :infinite_times,
    adapter: Ecto.Adapters.Postgres
end
