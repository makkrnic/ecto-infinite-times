{:ok, _} = InfiniteTimes.Repo.start_link()

Ecto.Adapters.SQL.Sandbox.mode(InfiniteTimes.Repo, :manual)

ESpec.configure fn(config) ->
  config.before fn(tags) ->
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(InfiniteTimes.Repo)
    {:shared, tags: tags}
  end

  config.finally fn(_shared) ->
    :ok = Ecto.Adapters.SQL.Sandbox.checkin(InfiniteTimes.Repo, [])
  end
end
