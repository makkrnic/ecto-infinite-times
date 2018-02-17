defmodule InfiniteTimes.Ecto.InfDateSpec do
  use ESpec
  alias InfiniteTimes.Ecto.InfDate

  describe "cast/1" do
    context "with only finitness provided" do
      context ":infinity" do
        it "creates the InfDate" do
          :infinity
          |> InfDate.cast()
          |> should(match_pattern {:ok, %InfiniteTimes.InfDate{}})
        end
      end

      context ":neg_infinity" do
        it "creates the InfDate" do
          :neg_infinity
          |> InfDate.cast()
          |> should(match_pattern {:ok, %InfiniteTimes.InfDate{}})
        end
      end

      context ":finite" do
        it "returns an error" do
          :finite
          |> InfDate.cast()
          |> should(eq :error)
        end
      end
    end

    context "with %InfiniteTimes.InfDate{} provided" do
      it "returns the InfDate" do
        :infinity
        |> InfiniteTimes.InfDate.new()
        |> InfDate.cast()
        |> should(match_pattern {:ok, %InfiniteTimes.InfDate{}})
      end
    end

    context "with %Date{} provided" do
      it "creates the InfDate" do
        Date.utc_today
        |> InfDate.cast()
        |> should(match_pattern {:ok, %InfiniteTimes.InfDate{}})
      end
    end

    context "when provided with binary castable by `Ecto.Date`" do
      it "creates the InfDate" do
        "2312-11-22"
        |> InfDate.cast()
        |> should(match_pattern {:ok, %InfiniteTimes.InfDate{}})
      end
    end
  end

  describe "load/1" do
    context "with only finitness provided" do
      context ":infinity" do
        it "returns the InfDate" do
          :infinity
          |> InfDate.load()
          |> should(match_pattern {:ok, %InfiniteTimes.InfDate{}})
        end
      end

      context ":neg_infinity" do
        it "returns the InfDate" do
          :neg_infinity
          |> InfDate.cast()
          |> should(match_pattern {:ok, %InfiniteTimes.InfDate{}})
        end
      end

      context ":finite" do
        it "returns an error" do
          :finite
          |> InfDate.cast()
          |> should(eq :error)
        end
      end
    end

    context "with date triplet and :finite provided" do
      it "returns the InfDate" do
        {{2000, 1, 2}, :finite}
        |> InfDate.load()
        |> should(match_pattern {:ok, %InfiniteTimes.InfDate{}})
      end
    end

    context "with only date triplet provided" do
      it "returns the `:finite` InfDate" do
        {2000, 1, 2}
        |> InfDate.load()
        |> should(match_pattern {:ok, %InfiniteTimes.InfDate{finitness: :finite}})
      end
    end

    context "with invalid input" do
      it "returns an error" do
        nil
        |> InfDate.load()
        |> should(eq :error)
      end
    end
  end

  describe "dump/1" do
    context "with infinite date" do
      context ":infinity" do
        it "returns the finitness" do
          :infinity
          |> InfiniteTimes.InfDate.new()
          |> InfDate.dump()
          |> should(match_pattern {:ok, :infinity})
        end
      end

      context ":neg_infinity" do
        it "returns the finitness" do
          :neg_infinity
          |> InfiniteTimes.InfDate.new()
          |> InfDate.dump()
          |> should(match_pattern {:ok, :neg_infinity})
        end
      end
    end

    context "with finite date" do
      it "returns the date triplet" do
        %Date{year: 2009, month: 6, day: 10}
        |> InfiniteTimes.InfDate.new()
        |> InfDate.dump()
        |> should(match_pattern {:ok, {2009, 6, 10}})
      end
    end

    context "for invalid input" do
      it "returns an error" do
        %Date{year: 2000, month: 1, day: 1} # wrong type
        |> InfDate.dump()
        |> should(eq :error)
      end
    end
  end
end
