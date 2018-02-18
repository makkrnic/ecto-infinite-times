defmodule InfiniteTimes.InfDate do
  @moduledoc """
  Date type supporting infinity
  """

  defstruct [:date, :finitness]

  @type t ::
          %__MODULE__{date: %Date{}, finitness: :finite}
          | %__MODULE__{date: nil, finitness: :infinity | :neg_infinity}

  @spec new(atom()) :: t
  def new(:infinity), do: %__MODULE__{date: nil, finitness: :infinity}
  def new(:neg_infinity), do: %__MODULE__{date: nil, finitness: :neg_infinity}
  def new(%Date{} = date), do: %__MODULE__{date: date, finitness: :finite}
  def new({_, _, _} = date), do: date |> Date.from_erl! |> new()

  def from_erl(erl_date) do
    case erl_date |> Date.from_erl() do
      {:ok, date} -> {:ok, date |> new()}
      x -> x
    end
  end

  @spec compare(t, t) :: :lt | :eq | :gt
  def compare(%__MODULE__{finitness: :infinity}, %__MODULE__{finitness: :infinity}), do: :eq
  def compare(%__MODULE__{finitness: :infinity}, _), do: :gt
  def compare(_, %__MODULE__{finitness: :infinity}), do: :lt

  def compare(%__MODULE__{finitness: :neg_infinity}, %__MODULE__{finitness: :neg_infinity}),
    do: :eq

  def compare(%__MODULE__{finitness: :neg_infinity}, _), do: :lt
  def compare(_, %__MODULE__{finitness: :neg_infinity}), do: :gt

  def compare(%__MODULE__{date: left, finitness: :finite}, %__MODULE__{
        date: right,
        finitness: :finite
      }),
      do: Date.compare(left, right)

  @spec is?(:lt | :lte | :eq | :gte | :gt, t(), t()) :: boolean()
  def is?(:gte, %__MODULE__{} = left, %__MODULE__{} = right),
    do: compare(left, right) in [:eq, :gt]

  def is?(:lte, %__MODULE__{} = left, %__MODULE__{} = right),
    do: compare(left, right) in [:eq, :lt]

  def is?(op, %__MODULE__{} = left, %__MODULE__{} = right), do: compare(left, right) == op
end
