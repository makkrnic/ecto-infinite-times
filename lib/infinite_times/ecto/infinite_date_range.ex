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
    lower = lower |> unbound_nil_or(:neg_infinity) |> InfiniteTimes.InfDate.new()
    upper = upper |> unbound_nil_or(:infinity) |> InfiniteTimes.InfDate.new()
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

  defp unbound_nil_or(:unbound, default), do: default
  defp unbound_nil_or(nil, default), do: default
  defp unbound_nil_or(v, _), do: v

  @impl true
  def equal?(%{upper: left_upper, lower: left_lower}, %{upper: right_upper, lower: right_lower}) do
    InfiniteTimes.Ecto.InfDate.equal?(left_lower, right_lower) && InfiniteTimes.Ecto.InfDate.equal?(left_upper, right_upper)
  end

  def equal?(_, _), do: false
end
