defmodule InfiniteTimes.Repo.Migrations.CreateInfiniteDateranges do
  use Ecto.Migration

  def change do
    create table(:infinite_date_ranges) do
      add :the_range, :daterange
    end
  end
end
