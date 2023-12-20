defmodule Pos do
  defstruct [:dir, :pos]
end

defmodule Aoc2023.Day16 do
  def etl_input(part) do
    Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part) |> process()
  end

  def part1(part \\ :ex1) do
    etl_input(part)
    |> energized([%Pos{dir: :east, pos: {0, 0}}])
  end

  def part2(part \\ :ex2) do
    map = etl_input(part)
    {n_rows, n_cols} = map_bounds(map)

    for r <- 0..n_rows,
        c <- 0..n_cols,
        r == 0 or c == 0 or r == n_rows or c == n_cols,
        reduce: 0 do
      acc ->
        l =
          cond do
            r == 0 and c == 0 ->
              Enum.max([
                energized(map, [%Pos{dir: :east, pos: {r, c}}]),
                energized(map, [%Pos{dir: :south, pos: {r, c}}])
              ])

            r == 0 and c == n_cols ->
              Enum.max([
                energized(map, [%Pos{dir: :west, pos: {r, c}}]),
                energized(map, [%Pos{dir: :south, pos: {r, c}}])
              ])

            r == n_rows and c == 0 ->
              Enum.max([
                energized(map, [%Pos{dir: :east, pos: {r, c}}]),
                energized(map, [%Pos{dir: :north, pos: {r, c}}])
              ])

            r == n_rows and c == n_cols ->
              Enum.max([
                energized(map, [%Pos{dir: :west, pos: {r, c}}]),
                energized(map, [%Pos{dir: :north, pos: {r, c}}])
              ])

            r == 0 ->
              energized(map, [%Pos{dir: :south, pos: {r, c}}])

            r == n_rows ->
              energized(map, [%Pos{dir: :north, pos: {r, c}}])

            c == 0 ->
              energized(map, [%Pos{dir: :east, pos: {r, c}}])

            c == n_cols ->
              energized(map, [%Pos{dir: :west, pos: {r, c}}])
          end

        cond do
          l > acc -> l
          true -> acc
        end
    end
  end

  def energized(map, start) do
    traverse_path(map, start)
    |> MapSet.to_list()
    |> Enum.map(fn %Pos{dir: _, pos: {r, c}} -> {r, c} end)
    |> Enum.uniq()
    |> length()
  end

  def process(input) do
    input
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, r} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.map(fn {tile, c} -> {{r, c}, tile} end)
    end)
    |> Map.new()
  end

  def next_pos(%Pos{dir: dir, pos: {r, c}}, ".") do
    case dir do
      :east -> [%Pos{dir: :east, pos: {r, c + 1}}]
      :north -> [%Pos{dir: :north, pos: {r - 1, c}}]
      :west -> [%Pos{dir: :west, pos: {r, c - 1}}]
      :south -> [%Pos{dir: :south, pos: {r + 1, c}}]
    end
  end

  def next_pos(%Pos{dir: dir, pos: {r, c}}, "-") do
    cond do
      dir == :north or dir == :south ->
        [%Pos{dir: :east, pos: {r, c + 1}}, %Pos{dir: :west, pos: {r, c - 1}}]

      dir == :east ->
        [%Pos{dir: :east, pos: {r, c + 1}}]

      dir == :west ->
        [%Pos{dir: :west, pos: {r, c - 1}}]
    end
  end

  def next_pos(%Pos{dir: dir, pos: {r, c}}, "|") do
    cond do
      dir == :east or dir == :west ->
        [%Pos{dir: :north, pos: {r - 1, c}}, %Pos{dir: :south, pos: {r + 1, c}}]

      dir == :north ->
        [%Pos{dir: :north, pos: {r - 1, c}}]

      dir == :south ->
        [%Pos{dir: :south, pos: {r + 1, c}}]
    end
  end

  def next_pos(%Pos{dir: dir, pos: {r, c}}, "\\") do
    case dir do
      :east -> [%Pos{dir: :south, pos: {r + 1, c}}]
      :north -> [%Pos{dir: :west, pos: {r, c - 1}}]
      :west -> [%Pos{dir: :north, pos: {r - 1, c}}]
      :south -> [%Pos{dir: :east, pos: {r, c + 1}}]
    end
  end

  def next_pos(%Pos{dir: dir, pos: {r, c}}, "/") do
    case dir do
      :east -> [%Pos{dir: :north, pos: {r - 1, c}}]
      :north -> [%Pos{dir: :east, pos: {r, c + 1}}]
      :west -> [%Pos{dir: :south, pos: {r + 1, c}}]
      :south -> [%Pos{dir: :west, pos: {r, c - 1}}]
    end
  end

  def map_bounds(map) do
    {map |> Map.keys() |> Enum.map(fn {r, _} -> r end) |> Enum.max(),
     map |> Map.keys() |> Enum.map(fn {_, c} -> c end) |> Enum.max()}
  end

  def traverse_path(map, pos) do
    {n_rows, n_cols} = map_bounds(map)
    traverse_path(map, pos, MapSet.new(pos), n_rows, n_cols)
  end

  def traverse_path(map, pos, cache, n_rows, n_cols) do
    next_pos =
      pos
      |> Enum.flat_map(fn p = %Pos{dir: _, pos: curr_pos} ->
        next_pos(p, map[curr_pos])
      end)
      |> Enum.reject(fn pos = %Pos{dir: _, pos: {r, c}} ->
        r < 0 or c < 0 or r > n_rows or c > n_cols or pos in cache
      end)

    for p <- next_pos, reduce: cache do
      acc ->
        traverse_path(map, [p], MapSet.put(acc, p), n_rows, n_cols)
    end
  end
end
