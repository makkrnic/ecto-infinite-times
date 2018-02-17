defmodule InfiniteTimes.Repo.Migrations.CreateInfiniteDates do
  use Ecto.Migration

  def change do
    create table(:infinite_dates) do
      add :the_date, :date
    end
  end
end
