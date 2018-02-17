defmodule InfiniteTimes.InfiniteDateRangeSpec do
  use ESpec
  alias InfiniteTimes.InfDate
  alias InfiniteTimes.InfiniteDateRange

  describe "new/2" do
    context "when provided `InfDate`'s" do
      it "returns the range consisting of the provided params" do
        lower = InfDate.new ~D[2018-01-05]
        upper = InfDate.new ~D[2018-02-05]

        InfiniteDateRange.new(lower, upper)
        |> should(match_pattern %InfiniteDateRange{lower: lower, upper: upper})
      end
    end

    context "when lower bound is `nil`" do
      it "returns the range with negative infinity as lower bound" do
        upper = InfDate.new ~D[2018-01-05]

        InfiniteDateRange.new(nil, upper)
        |> should(match_pattern %InfiniteDateRange{lower: %InfDate{finitness: :neg_infinity}, upper: upper})
      end
    end

    context "when upper bound is `nil`" do
      it "returns the range with infinity as upper bound" do
        lower = InfDate.new ~D[2018-01-05]

        InfiniteDateRange.new(lower, nil)
        |> should(match_pattern %InfiniteDateRange{lower: lower, upper: %InfDate{finitness: :infinity}})
      end
    end
  end

  describe "includes?/2" do
    let :range, do: InfiniteDateRange.new(InfDate.new(~D[2018-01-05]), InfDate.new(~D[2018-02-05]))
    let :in_range, do: [
      ~D[2018-01-05],
      ~D[2018-02-04],
      ~D[2018-01-25],
    ]
    let :not_in_range, do: [
      ~D[2018-01-04],
      ~D[2018-02-05],
      ~D[2018-02-25],
    ]


    context "when provided with %InfDate{}" do
      context "when the date is in range" do
        it "returns true" do
          in_range()
          |> Enum.each(fn(d) ->
            assert InfiniteDateRange.includes?(range(), InfDate.new(d))
          end)
        end
      end

      context "when the date is not in range" do
        it "returns false" do
          not_in_range() ++ [:infinity, :neg_infinity]
          |> Enum.each(fn(d) ->
            refute InfiniteDateRange.includes?(range(), InfDate.new(d))
          end)
        end
      end
    end

    context "when provided with %Date{}" do
      context "when the date is in range" do
        it "returns true" do
          in_range()
          |> Enum.each(fn(d) ->
            assert InfiniteDateRange.includes?(range(), d)
          end)
        end
      end

      context "when the date is not in range" do
        it "returns false" do
          not_in_range()
          |> Enum.each(fn(d) ->
            refute InfiniteDateRange.includes?(range(), d)
          end)
        end
      end
    end
  end
end
