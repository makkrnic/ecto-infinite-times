defmodule InfiniteTimes.Ecto.InfDate do
  @moduledoc """
  Ecto adapter for InfiniteTimes.InfDate
  """
  @behaviour Ecto.Type

  def type, do: :date

  def cast(finitness) when finitness in [:infinity, :neg_infinity],
    do: {:ok, InfiniteTimes.InfDate.new(finitness)}
  def cast(%InfiniteTimes.InfDate{} = d),
    do: {:ok, d}
  def cast(%Date{} = d),
    do: {:ok, d |> InfiniteTimes.InfDate.new()}
  def cast(d) when is_binary(d) do
    with {:ok, date} <- Ecto.Date.cast(d),
      {:ok, date} <- Date.new(date.year, date.month, date.day) do
        {:ok, date |> InfiniteTimes.InfDate.new}
      else
        _ -> :error
    end
  end
  def cast(_), do: :error

  def load(finitness) when finitness in [:infinity, :neg_infinity] do
    {:ok, InfiniteTimes.InfDate.new(finitness)}
  end
  def load({{year, month, day}, :finite}) do
    case Date.new(year, month, day) do
      {:ok, date} -> {:ok, date |> InfiniteTimes.InfDate.new()}
      _ -> :error
    end
  end
  def load(_), do: :error

  def dump(%InfiniteTimes.InfDate{finitness: finitness}) when finitness in [:infinity, :neg_infinity] do
    {:ok, finitness}
  end
  def dump(%InfiniteTimes.InfDate{date: %Date{year: year, month: month, day: day}, finitness: :finite}) do
    {:ok, {year, month, day}}
  end
  def dump(_), do: :error
end
