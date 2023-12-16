defmodule Aoc2023.Day14 do
  def etl_input(part) do
    Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part) |> process()
  end

  def part1(part \\ :ex1) do
    etl_input(part)
    |> roll_north()
    |> count()
  end

  def part2(part \\ :ex2) do
    {stop, start, i_map} =
      etl_input(part)
      |> cycle(0)

    period = stop - start
    final = rem(1_000_000_000 - start, period) + start
    count(i_map[final])
  end

  def process(input) do
    input |> Enum.map(&String.graphemes/1)
  end

  def roll(mat, dir) do
    sort_dir =
      case dir do
        :up -> :desc
        :down -> :asc
      end

    for l <- mat do
      l
      |> String.split("#")
      |> Enum.map(&(String.graphemes(&1) |> Enum.sort(sort_dir)))
      |> Enum.join("#")
      |> String.graphemes()
    end
  end

  def roll_north(mat) do
    mat
    |> Aoc2023.transpose()
    |> Enum.map(&Enum.join(&1))
    |> roll(:up)
    |> Aoc2023.transpose()
  end

  def roll_west(mat) do
    mat
    |> Enum.map(&Enum.join(&1))
    |> roll(:up)
  end

  def roll_east(mat) do
    mat
    |> Enum.map(&Enum.join(&1))
    |> roll(:down)
  end

  def roll_south(mat) do
    mat
    |> Aoc2023.transpose()
    |> Enum.map(&Enum.join(&1))
    |> roll(:down)
    |> Aoc2023.transpose()
  end

  def rotate_anti_clockwise(mat) do
    mat
    |> Enum.map(&Enum.reverse/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  def count(mat) do
    for l <- mat |> Aoc2023.transpose(), reduce: 0 do
      acc ->
        acc +
          (l
           |> Enum.reverse()
           |> Enum.with_index()
           |> Enum.filter(fn {c, _i} -> c == "O" end)
           |> Enum.reduce(0, fn {_, i}, acc -> acc + (i + 1) end))
    end
  end

  def cycle(mat, 0), do: cycle(mat, 1, %{mat => 0}, %{0 => mat})

  def cycle(mat, i, map, inverse_map) do
    r =
      mat
      |> roll_north()
      |> roll_west()
      |> roll_south()
      |> roll_east()

    cond do
      Map.has_key?(map, r) ->
        {i, map[r], Map.put(inverse_map, i, r)}

      true ->
        cycle(r, i + 1, Map.put(map, r, i), Map.put(inverse_map, i, r))
    end
  end
end
