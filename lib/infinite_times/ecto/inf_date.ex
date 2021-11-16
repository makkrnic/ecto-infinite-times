defmodule InfiniteTimes.Ecto.InfDate do
  @moduledoc """
  Ecto adapter for InfiniteTimes.InfDate
  """
  @behaviour Ecto.Type

  @impl Ecto.Type
  def type, do: :date

  @impl Ecto.Type
  def cast(finitness) when finitness in [:infinity, :neg_infinity],
    do: {:ok, InfiniteTimes.InfDate.new(finitness)}

  def cast(%InfiniteTimes.InfDate{} = d), do: {:ok, d}
  def cast(%Date{} = d), do: {:ok, d |> InfiniteTimes.InfDate.new()}

  def cast(d) when is_binary(d) do
    with {:ok, date} <- Date.from_iso8601(d),
         {:ok, date} <- Date.new(date.year, date.month, date.day) do
      {:ok, date |> InfiniteTimes.InfDate.new()}
    else
      _ -> :error
    end
  end

  def cast(_), do: :error

  @impl Ecto.Type
  def load(finitness) when finitness in [:infinity, :neg_infinity] do
    {:ok, InfiniteTimes.InfDate.new(finitness)}
  end

  def load({_, _, _} = d), do: load({d, :finite})

  def load({{year, month, day}, :finite}) do
    case Date.new(year, month, day) do
      {:ok, date} -> {:ok, date |> InfiniteTimes.InfDate.new()}
      _ -> :error
    end
  end

  def load(_), do: :error

  @impl Ecto.Type
  def dump(%InfiniteTimes.InfDate{} = date) do
    {:ok, date}
  end

  def dump(_), do: :error

  @impl true
  def equal?(left, right), do: InfiniteTimes.InfDate.is?(:eq, left, right)
end
