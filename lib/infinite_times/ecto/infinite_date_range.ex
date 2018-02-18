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

  # TODO: see if possible to use Postgrex.Range as a backing type
  @impl Ecto.Type
  @spec load({%Date{} | :infinity | :neg_infinity, %Date{} | :infinity | :neg_infinity}) ::
          %InfiniteTimes.InfiniteDateRange{}
  def load({lower, upper}) do
    lower = lower |> InfiniteTimes.InfDate.new()
    upper = upper |> InfiniteTimes.InfDate.new()
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
      {:ok, %InfiniteTimes.InfiniteDateRange{lower: lower, upper: upper}}
    else
      _ -> :error
    end
  end

  def dump(_), do: :error
end
