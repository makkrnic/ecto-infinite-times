defmodule InfiniteTimes.Ecto.InfiniteDateRange do
  @moduledoc """
  Ecto adapter for InfiniteTimes.InfiniteDateRange
  """
  @behaviour Ecto.Type

  @impl Ecto.Type
  def type, do: :daterange

  @impl Ecto.Type
  def cast(%InfiniteTimes.InfiniteDateRange{} = range), do: {:ok, range}

  def cast({lower, upper}) do
    case InfiniteTimes.InfiniteDateRange.new(lower, upper) do
      :error -> :error
      d -> {:ok, d}
    end
  end

  def cast(_), do: :error

  @impl Ecto.Type
  @spec load(%Postgrex.Range{}) :: %InfiniteTimes.InfiniteDateRange{}
  def load(%Postgrex.Range{lower: lower, upper: upper}) do
    lower = lower |> nil_or(:neg_infinity) |> InfiniteTimes.InfDate.new()
    upper = upper |> nil_or(:infinity) |> InfiniteTimes.InfDate.new()
    {:ok, InfiniteTimes.InfiniteDateRange.new(lower, upper)}
  end

  @spec load(any()) :: :error
  def load(_), do: :error

  @impl Ecto.Type
  def dump(%InfiniteTimes.InfiniteDateRange{
        lower: %InfiniteTimes.InfDate{} = lower,
        upper: %InfiniteTimes.InfDate{} = upper
      }) do
    with {:ok, lower} <- InfiniteTimes.Ecto.InfDate.dump(lower),
         {:ok, upper} <- InfiniteTimes.Ecto.InfDate.dump(upper) do
      {:ok, %Postgrex.Range{lower: lower, upper: upper, upper_inclusive: false}}
    else
      _ -> :error
    end
  end

  def dump(_), do: :error

  defp nil_or(nil, default), do: default
  defp nil_or(v, _), do: v
end
