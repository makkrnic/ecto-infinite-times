defmodule InfiniteTimes.Postgrex.InfiniteDateRangeSpec do
  use ESpec
  alias InfiniteTimes.Model.InfiniteDateRange
  alias InfiniteTimes.Repo

  describe "loading from db" do
    it "loads boundedi range correctly" do
      expected_range = InfiniteTimes.InfiniteDateRange.new(~D[2018-01-02], ~D[2018-02-02])

      new_id = Ecto.Adapters.SQL.query!(Repo, "INSERT INTO infinite_date_ranges (the_range) VALUES (daterange('2018-01-02','2018-02-02')) RETURNING id;")
      |> Map.get(:rows)
      |> Enum.at(0)
      |> Enum.at(0)

      InfiniteDateRange
      |> Repo.get(new_id)
      |> Map.get(:the_range)
      |> should(match_pattern ^expected_range)
    end

    it "loads upper unbounded range correctly" do
      expected_range = InfiniteTimes.InfiniteDateRange.new(~D[2018-01-02], nil)

      new_id = Ecto.Adapters.SQL.query!(Repo, "INSERT INTO infinite_date_ranges (the_range) VALUES (daterange('2018-01-02','infinity')) RETURNING id;")
      |> Map.get(:rows)
      |> Enum.at(0)
      |> Enum.at(0)

      InfiniteDateRange
      |> Repo.get(new_id)
      |> Map.get(:the_range)
      |> should(match_pattern ^expected_range)
    end

    it "loads lower unbounded range correctly" do
      expected_range = InfiniteTimes.InfiniteDateRange.new(nil, ~D[2018-01-02])

      new_id = Ecto.Adapters.SQL.query!(Repo, "INSERT INTO infinite_date_ranges (the_range) VALUES (daterange('-infinity','2018-01-02')) RETURNING id;")
      |> Map.get(:rows)
      |> Enum.at(0)
      |> Enum.at(0)

      InfiniteDateRange
      |> Repo.get(new_id)
      |> Map.get(:the_range)
      |> should(match_pattern ^expected_range)
    end
  end

  describe "saving to db" do
    it "saves normal bounded range correctly" do
      expected_range = InfiniteTimes.InfiniteDateRange.new(~D[2018-01-02], ~D[2018-02-03])

      ret = %InfiniteDateRange{}
      |> Ecto.Changeset.cast(%{the_range: {~D[2018-01-02], ~D[2018-02-03]}}, [:the_range])
      |> Repo.insert

      ret
      |> should(match_pattern {:ok, _})

      {:ok, d} = ret

      InfiniteDateRange
      |> Repo.get(d.id)
      |> Map.get(:the_range)
      |> should(match_pattern ^expected_range)
    end

    it "saves the upper unbounded range correctly" do
      expected_range = InfiniteTimes.InfiniteDateRange.new(~D[2018-01-02], nil)

      ret = %InfiniteDateRange{}
      |> Ecto.Changeset.cast(%{the_range: {~D[2018-01-02], nil}}, [:the_range])
      |> Repo.insert

      ret
      |> should(match_pattern {:ok, _})

      {:ok, d} = ret

      InfiniteDateRange
      |> Repo.get(d.id)
      |> Map.get(:the_range)
      |> should(match_pattern ^expected_range)
    end

    it "saves the lower unbounded range correctly" do
      expected_range = InfiniteTimes.InfiniteDateRange.new(nil, ~D[2018-01-02])

      ret = %InfiniteDateRange{}
      |> Ecto.Changeset.cast(%{the_range: {nil, ~D[2018-01-02]}}, [:the_range])
      |> Repo.insert

      ret
      |> should(match_pattern {:ok, _})

      {:ok, d} = ret

      InfiniteDateRange
      |> Repo.get(d.id)
      |> Map.get(:the_range)
      |> should(match_pattern ^expected_range)
    end
  end
end
