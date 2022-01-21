if Code.ensure_loaded?(Postgrex) do
  defmodule InfiniteTimes.PostgrexTypes.InfDate do
    @moduledoc """
    An extension that implements postgres' native support for positive and negative infinite dates
    """

    import Postgrex.BinaryUtils, warn: false
    use Postgrex.BinaryExtension, send: "date_send"

    @gd_epoch :calendar.date_to_gregorian_days({2000, 1, 1})
    @max_year 5_874_897
    @postgrex_date_infinity 2_147_483_647
    @postgrex_date_neg_infinity -2_147_483_648

    # @impl Postgrex.Extension
    def encode(_) do
      quote location: :keep do
        %InfiniteTimes.InfDate{} = date ->
          unquote(__MODULE__).encode_inf_date(date)

        other ->
          raise ArgumentError, Postgrex.Utils.encode_msg(other, InfiniteTimes.InfDate)
      end
    end

    def encode_inf_date(%InfiniteTimes.InfDate{finitness: :infinity}),
      do: <<4::int32, @postgrex_date_infinity::int32>>

    def encode_inf_date(%InfiniteTimes.InfDate{finitness: :neg_infinity}),
      do: <<4::int32, @postgrex_date_neg_infinity::int32>>

    def encode_inf_date(%InfiniteTimes.InfDate{
          date: %Date{year: year, month: month, day: day} = date,
          finitness: :finite
        })
        when year <= @max_year do
      <<4::int32, Date.to_gregorian_days(date) - @gd_epoch::int32>>
    end

    # @impl Postgrex.Extension
    def decode(_) do
      quote location: :keep do
        <<4::int32, days::int32>> ->
          unquote(__MODULE__).days_to_inf_date(days)
      end
    end

    def days_to_inf_date(days) do
      case days do
        @postgrex_date_infinity ->
          :infinity

        @postgrex_date_neg_infinity ->
          :neg_infinity

        d when d + unquote(@gd_epoch) < 0 ->
          Date.from_gregorian_days(0)

        _ ->
          Date.from_gregorian_days(days + unquote(@gd_epoch))
      end
    end
  end
end
