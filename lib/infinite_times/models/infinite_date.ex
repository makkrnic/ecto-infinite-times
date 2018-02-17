defmodule InfiniteTimes.InfiniteDate do
  use Ecto.Schema

  schema "infinite_dates" do
    field(:the_date, InfiniteTimes.Ecto.InfDate)
  end
end
