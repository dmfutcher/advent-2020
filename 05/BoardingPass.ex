defmodule BoardingPass do

  def load_input do
    File.read!("input")
      |> String.split("\n", trim: true)
      |> Enum.map(&(&1 |> tree_instructions |> Enum.split(7)))
  end

  defp binary_partition(min, max, instr) do
    mid = Integer.floor_div(min + max, 2)

    case {min, max, instr} do
      {_, max, []} -> max
      {min, _, [:left | tail]} -> binary_partition(min, mid, tail)
      {_, max, [:right | tail]} -> binary_partition(mid, max, tail)
    end
  end

  defp get_row(row_desc) do
    binary_partition(0, 127, row_desc)
  end

  defp get_column(col_desc) do
    binary_partition(0, 7, col_desc)
  end

  defp tree_instructions(str) do
    l_or_r = fn
      l when l in ["F", "L"] -> :left
      r when r in ["B", "R"] -> :right
    end

    str |> String.graphemes |> Enum.map(l_or_r)
  end

  def get_seat_id({row_desc, col_desc}) do
    get_row(row_desc) * 8 + get_column(col_desc)
  end

  def get_seats() do
    BoardingPass.load_input
      |> Enum.map(&(BoardingPass.get_seat_id &1))
  end

end
