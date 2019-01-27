defmodule InfiniteTimes.Ecto.InfiniteDateRangeSpec do
  use ESpec
  alias InfiniteTimes.InfDate
  alias InfiniteTimes.Ecto.InfiniteDateRange

  describe "cast/1" do
    context "when provided with %InfiniteDateRange{}" do
      it "casts sucessfully" do
        range = InfiniteTimes.InfiniteDateRange.new(InfDate.new(~D[2018-01-05]), InfDate.new(~D[2018-02-05]))
        range
        |> InfiniteDateRange.cast()
        |> should(match_pattern {:ok, ^range})
      end
    end

    context "when provided with valid tuple" do
      context "as `%Date{}`'s" do
        let :valid_tuples, do: [
          {~D[2018-01-05], ~D[2018-02-05]},
          {~D[2018-01-05], nil},
          {nil, ~D[2018-02-05]},
          {nil, nil},
        ]

        it "casts successfully" do
          valid_tuples()
          |> Enum.each(fn (tuple) ->
            tuple
            |> InfiniteDateRange.cast()
            |> should(match_pattern {:ok, _})
          end)
        end
      end

      context "as `%InfDate{}`'s" do
        let :valid_tuples, do: [
          {~D[2018-01-05], ~D[2018-02-05]},
          {~D[2018-01-05], :infinity},
          {:neg_infinity, ~D[2018-02-05]},
          {:neg_infinity, :infinity},
        ]

        it "casts successfully" do
          valid_tuples()
          |> Enum.each(fn ({lower, upper}) ->
            {InfDate.new(lower), InfDate.new(upper)}
            |> InfiniteDateRange.cast()
            |> should(match_pattern {:ok, _})
          end)
        end
      end
    end
  end

  describe "load/1" do
    let :valid_tuples, do: [
      %Postgrex.Range{lower: ~D[2018-01-05], upper: ~D[2018-02-05]},
      %Postgrex.Range{lower: ~D[2018-01-05], upper: :infinity},
      %Postgrex.Range{lower: ~D[2018-01-05], upper: nil},
      %Postgrex.Range{lower: :neg_infinity,  upper: ~D[2018-02-05]},
      %Postgrex.Range{lower: :nil,  upper: ~D[2018-02-05]},
      %Postgrex.Range{lower: :neg_infinity,  upper: :infinity},
      %Postgrex.Range{lower: nil,  upper: nil},
    ]

    context "with valid tuples" do
      it "returns the InfiniteDateRange" do
        valid_tuples()
        |> Enum.each(fn (range) ->
          range
          |> InfiniteDateRange.load()
          |> should(match_pattern {:ok, %InfiniteTimes.InfiniteDateRange{}})
        end)
      end
    end

    context "with invalid args" do
      it "returns :error" do
        nil
        |> InfiniteDateRange.load()
        |> should(eq :error)
      end
    end
  end

  describe "dump/1" do
    context "when provided with InfiniteDateRange" do
      let :valid_tuples, do: [
        {~D[2018-01-05], ~D[2018-02-05]},
        {~D[2018-01-05], nil},
        {nil, ~D[2018-02-05]},
        {nil, nil},
      ]

      it "returns {:ok, %Postgrex.Range}" do
        valid_tuples()
        |> Enum.map(fn (tuple) ->
          {:ok, range} = tuple
          |> InfiniteDateRange.cast()
          range
        end)
        |> Enum.each(fn (range) ->
          range
          |> InfiniteDateRange.dump()
          |> should(match_pattern {:ok, %Postgrex.Range{}})
        end)
      end
    end
  end
end
