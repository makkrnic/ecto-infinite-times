defmodule InfiniteTimes.Postgrex.InfiniteDateSpec do
  use ESpec
  alias InfiniteTimes.InfiniteDate
  alias InfiniteTimes.Repo

  describe "loading from db" do
    it "loads normal date correctly" do
      new_id = Ecto.Adapters.SQL.query!(Repo, "INSERT INTO infinite_dates (the_date) VALUES ('2018-01-02') RETURNING id;")
      |> Map.get(:rows)
      |> Enum.at(0)
      |> Enum.at(0)

      InfiniteDate
      |> Repo.get(new_id)
      |> Map.get(:the_date)
      |> should(match_pattern %InfiniteTimes.InfDate{date: %Date{year: 2018, month: 1, day: 2}, finitness: :finite})
    end

    it "loads positive infinite date correctly" do
      new_id = Ecto.Adapters.SQL.query!(Repo, "INSERT INTO infinite_dates (the_date) VALUES ('infinity') RETURNING id;")
      |> Map.get(:rows)
      |> Enum.at(0)
      |> Enum.at(0)

      InfiniteDate
      |> Repo.get(new_id)
      |> Map.get(:the_date)
      |> should(match_pattern %InfiniteTimes.InfDate{date: nil, finitness: :infinity})
    end

    it "loads negative infinite date correctly" do
      new_id = Ecto.Adapters.SQL.query!(Repo, "INSERT INTO infinite_dates (the_date) VALUES ('-infinity') RETURNING id;")
      |> Map.get(:rows)
      |> Enum.at(0)
      |> Enum.at(0)

      InfiniteDate
      |> Repo.get(new_id)
      |> Map.get(:the_date)
      |> should(match_pattern %InfiniteTimes.InfDate{date: nil, finitness: :neg_infinity})
    end
  end

  describe "saving to db" do
    it "saves normal date correctly" do
      ret = %InfiniteDate{}
      |> Ecto.Changeset.cast(%{the_date: ~D[2018-02-02]}, [:the_date])
      |> Repo.insert

      ret
      |> should(match_pattern {:ok, _})

      {:ok, d} = ret

      InfiniteDate
      |> Repo.get(d.id)
      |> Map.get(:the_date)
      |> should(match_pattern %InfiniteTimes.InfDate{date: ~D[2018-02-02], finitness: :finite})
    end

    it "saves the positive infinity correctly" do
      ret = %InfiniteDate{}
      |> Ecto.Changeset.cast(%{the_date: :infinity}, [:the_date])
      |> Repo.insert

      ret
      |> should(match_pattern {:ok, _})

      {:ok, d} = ret

      InfiniteDate
      |> Repo.get(d.id)
      |> Map.get(:the_date)
      |> should(match_pattern %InfiniteTimes.InfDate{date: nil, finitness: :infinity})
    end

    it "saves the negative infinity correctly" do
      ret = %InfiniteDate{}
      |> Ecto.Changeset.cast(%{the_date: :neg_infinity}, [:the_date])
      |> Repo.insert

      ret
      |> should(match_pattern {:ok, _})

      {:ok, d} = ret

      InfiniteDate
      |> Repo.get(d.id)
      |> Map.get(:the_date)
      |> should(match_pattern %InfiniteTimes.InfDate{date: nil, finitness: :neg_infinity})
    end
  end
end
