defmodule InfiniteTimes.Model.InfiniteDateRange do
  @moduledoc false
  use Ecto.Schema

  schema "infinite_date_ranges" do
    field(:the_range, InfiniteTimes.Ecto.InfiniteDateRange)
  end
end
