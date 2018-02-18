if Code.ensure_loaded?(Postgrex) do
  defmodule InfiniteTimes.PostgrexTypes.InfiniteDateRange do
    @moduledoc """
    An extension that implements postgres' native support for dateranges
    """

    import Postgrex.BinaryUtils, warn: false
    use Bitwise, only_operators: true
    alias InfiniteTimes.PostgrexTypes.InfDate
    @behaviour Postgrex.SuperExtension

    @range_lb_inc 0x02
    @range_lb_inf 0x08
    @range_ub_inf 0x10

    @impl Postgrex.SuperExtension
    def init(_), do: nil

    @impl Postgrex.SuperExtension
    def matching(_), do: [send: "range_send", type: "daterange"]

    @impl Postgrex.SuperExtension
    def format(_), do: :super_binary

    @impl Postgrex.SuperExtension
    def oids(%Postgrex.TypeInfo{base_type: base_oid}, _) do
      [base_oid]
    end

    @impl Postgrex.SuperExtension
    def encode(_) do
      quote location: :keep do
        %{lower: lower, upper: upper} = range, [_oid], [InfDate = type] ->
          # encode_value/2 defined by TypeModule
          lower = encode_value(lower, type)
          upper = encode_value(upper, type)
          unquote(__MODULE__).encode(range, lower, upper)

        other, _, _ ->
          raise ArgumentError, Postgrex.Utils.encode_msg(other, Postgrex.Range)
      end
    end

    @impl Postgrex.SuperExtension
    def decode(_) do
      quote location: :keep do
        <<len::int32, binary::binary-size(len)>>, [oid], [InfDate = type] ->
          <<flags, data::binary>> = binary
          # decode_list/2 and @null defined by TypeModule
          case decode_list(data, type) do
            [upper, lower] ->
              {lower, upper}

            empty_or_one ->
              nil
          end
      end
    end

    def encode(_, lower, upper) do
      flags = @range_lb_inc

      {flags, bin} =
        if lower == <<-1::int32>> do
          {flags ||| @range_lb_inf, ""}
        else
          {flags, lower}
        end

      {flags, bin} =
        if upper == <<-1::int32>> do
          {flags ||| @range_ub_inf, bin}
        else
          {flags, [bin | upper]}
        end

      [<<IO.iodata_length(bin) + 1::int32>>, flags | bin]
    end
  end
end
