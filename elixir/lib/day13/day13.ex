defmodule Aoc2023.Day13 do
  def etl_input(part) do
    Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input_raw(part) |> process()
  end

  def part1(part \\ :ex1) do
    for m <- etl_input(part), reduce: 0 do
      acc ->
        horiz = matrix_horizontal_symmetry(m, 1) |> Enum.reduce(0, &(&2 + &1 * 100))
        vert = m |> Aoc2023.transpose() |> matrix_horizontal_symmetry(1) |> Enum.sum()
        acc + horiz + vert
    end
  end

  def part2(part \\ :ex2) do
    for m <- etl_input(part), reduce: 0 do
      acc ->
        horiz =
          matrix_horizontal_symmetry(m, 2)
          |> Enum.reduce(0, &(&2 + &1 * 100))

        vert = m |> Aoc2023.transpose() |> matrix_horizontal_symmetry(2) |> Enum.sum()
        acc + horiz + vert
    end
  end

  def process(input) do
    for p <- String.split(input, "\n\n", trim: true) do
      for line <- p |> String.split("\n", trim: true), do: String.graphemes(line)
    end
  end

  def matrix_horizontal_symmetry(mat, part) do
    rows = length(mat)

    h1 =
      for r <- 1..div(rows, 2) do
        above = Enum.slice(mat, 0..(r - 1)) |> Enum.reverse()
        below = Enum.slice(mat, r..(2 * r - 1))

        diff =
          Enum.zip(above, below)
          |> Enum.map(fn {a, b} -> Enum.zip(a, b) |> Enum.reject(fn {a, b} -> a == b end) end)
          |> List.flatten()

        cond do
          part == 1 and diff == [] -> r
          part == 2 and length(diff) == 1 -> r
          true -> []
        end
      end

    h2 =
      for r <- (div(rows, 2) + 1)..(rows - 1) do
        above = Enum.slice(mat, (2 * r - rows)..(r - 1)) |> Enum.reverse()
        below = Enum.slice(mat, r..(rows - 1))

        diff =
          Enum.zip(above, below)
          |> Enum.map(fn {a, b} -> Enum.zip(a, b) |> Enum.reject(fn {a, b} -> a == b end) end)
          |> List.flatten()

        cond do
          part == 1 and diff == [] -> r
          part == 2 and length(diff) == 1 -> r
          true -> []
        end
      end

    [h1 | h2] |> List.flatten()
  end
end
