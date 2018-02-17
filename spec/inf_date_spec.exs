defmodule InfiniteTimes.InfDateSpec do
  use ESpec
  alias InfiniteTimes.InfDate

  describe "new/1" do
    context "for negative infinite date input" do
      it "creates the negative infinite date" do
        :neg_infinity
        |> InfDate.new
        |> should(match_pattern %InfDate{date: nil, finitness: :neg_infinity})
      end
    end

    context "for positive infinite date input" do
      it "creates the positive infinite date" do
        :infinity
        |> InfDate.new
        |> should(match_pattern %InfDate{date: nil, finitness: :infinity})
      end
    end

    context "for finite date input" do
      it "creates finite date" do
        Date.utc_today()
        |> InfDate.new
        |> should(match_pattern %InfDate{date: %Date{}, finitness: :finite})
      end
    end
  end

  describe "from_erl/1" do
    context "for valid date" do
      it "creates finite date" do
        {2018, 2, 10}
        |> InfDate.from_erl
        |> should(match_pattern {:ok, %InfDate{finitness: :finite}})
      end
    end

    context "for invalid date" do
      it "returns an error" do
        {2018, 2, 32}
        |> InfDate.from_erl
        |> should(match_pattern {:error, _})
      end
    end
  end
end
