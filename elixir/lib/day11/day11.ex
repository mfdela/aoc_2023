defmodule Aoc2023.Day11 do
  def etl_input(part),
    do: Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part) |> process()

  def part1(part \\ :ex1) do
    galaxies =
      etl_input(part)
      |> expand()
      |> find_galaxies()

    comb(2, galaxies)
    |> Enum.map(fn [g1, g2] -> manhattan_distance(g1, g2) end)
    |> Enum.sum()
  end

  def part2(part \\ :ex2, factor) do
    galaxies =
      etl_input(part)
      |> find_galaxies()

    sum =
      comb(2, galaxies)
      |> Enum.map(fn [g1, g2] -> manhattan_distance(g1, g2) end)
      |> Enum.sum()

    sum_expanded = part1(part)
    sum + (sum_expanded - sum) * (factor - 1)
  end

  def process(input) do
    input
    |> Enum.map(&String.graphemes/1)
  end

  def expand(map) do
    expand_rows_cols(map, [])
    |> transpose()
    |> expand_rows_cols([])
    |> transpose()
  end

  def expand_rows_cols([], acc), do: acc

  def expand_rows_cols([row | rest], acc) do
    cond do
      Enum.all?(row, &(&1 == ".")) -> expand_rows_cols(rest, acc ++ [row] ++ [row])
      true -> expand_rows_cols(rest, acc ++ [row])
    end
  end

  def transpose([]), do: []
  def transpose([[] | rest]), do: transpose(rest)

  def transpose([[first_elem | first_row] | rest]) do
    [
      [first_elem | for([h | _t] <- rest, do: h)]
      | transpose([first_row | for([_h | t] <- rest, do: t)])
    ]
  end

  def find_galaxies(map) do
    map
    |> Enum.map(fn row -> Enum.with_index(row) |> Enum.filter(fn {c, _} -> c == "#" end) end)
    |> Enum.with_index()
    |> Enum.reject(fn {l, _} -> l == [] end)
    |> Enum.map(fn {c, row} -> Enum.map(c, fn {_, col} -> {row, col} end) end)
    |> List.flatten()
  end

  def manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def comb(0, _), do: [[]]
  def comb(_, []), do: []

  def comb(m, [h | t]) do
    for(l <- comb(m - 1, t), do: [h | l]) ++ comb(m, t)
  end
end
