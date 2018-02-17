defmodule InfiniteTimes do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(InfiniteTimes.Repo, [])
    ]

    opts = [strategy: :one_for_one, name: InfiniteTimes.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
