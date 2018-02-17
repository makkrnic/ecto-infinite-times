defmodule InfiniteTimes.InfiniteDateRange do
  @moduledoc """
  Date range type supporting infinte bounds, with exclusive upper bound.
  """

  alias InfiniteTimes.InfDate

  defstruct [:upper, :lower]

  @type t :: %__MODULE__{lower: %InfDate{}, upper: %InfDate{}}

  @spec new(%InfDate{} | nil, %InfDate{} | nil) :: t
  def new(nil, upper), do: new(InfDate.new(:neg_infinity), upper)
  def new(lower, nil), do: new(lower, InfDate.new(:infinity))
  def new(%InfDate{} = lower, %InfDate{} = upper) do
    %__MODULE__{lower: lower, upper: upper}
  end

  @spec includes?(t(), %InfDate{} | %Date{}) :: boolean()
  def includes?(%__MODULE__{} = range, %Date{} = date), do: includes?(range, InfDate.new(date))
  def includes?(%__MODULE__{} = range, %InfDate{} = date) do
    InfDate.is?(:gte, date, range.lower) && InfDate.is?(:lt, date, range.upper)
  end
end
