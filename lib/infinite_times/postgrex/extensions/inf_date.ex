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
        {year, month, day} when year <= unquote(@max_year) ->
          date = {year, month, day}
          <<4::int32, :calendar.date_to_gregorian_days(date) - unquote(@gd_epoch)::int32>>

        :infinity ->
          <<4::int32, unquote(@postgrex_date_infinity)::int32>>

        :neg_infinity ->
          <<4::int32, unquote(@postgrex_date_neg_infinity)::int32>>
      end
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
          :calendar.gregorian_days_to_date(0)

        _ ->
          :calendar.gregorian_days_to_date(days + unquote(@gd_epoch))
      end
    end
  end
end
