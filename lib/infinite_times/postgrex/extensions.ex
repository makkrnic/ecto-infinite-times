if Code.ensure_loaded?(Postgrex) do
  Postgrex.Types.define(
    InfiniteTimes.PostgresTypes,
    [
      InfiniteTimes.PostgrexTypes.InfDate
    ] ++ Ecto.Adapters.Postgres.extensions(),
    json: Poison
  )
end
