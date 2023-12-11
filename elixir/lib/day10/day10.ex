defmodule Aoc2023.Day10 do
  @dir %{
    "S" => [[-1, 0], [1, 0], [0, -1], [0, 1]],
    "|" => [[-1, 0], [1, 0]],
    "-" => [[0, -1], [0, 1]],
    "L" => [[-1, 0], [0, 1]],
    "J" => [[-1, 0], [0, -1]],
    "7" => [[0, -1], [1, 0]],
    "F" => [[1, 0], [0, 1]]
  }

  def etl_input(part),
    do: Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part) |> process()

  def part1(part \\ :ex1) do
    etl_input(part)
    |> loop()
    |> then(fn x -> div(length(x), 2) end)
  end

  def part2(part \\ :ex2) do
    loop =
      etl_input(part) |> loop()

    # Pick's theorem
    # https://en.wikipedia.org/wiki/Pick%27s_theorem
    # A = num_internal_points + (boundary_points / 2) - 1
    # num_internal_points = A - (b/2) + 1
    abs(shoelace(loop)) - div(length(loop), 2) + 1
  end

  def process(input) do
    for {line, i} <- Enum.with_index(input), reduce: {%{}, [-1, -1]} do
      acc ->
        {map, [start_i, start_j]} = acc
        cols = line |> String.graphemes() |> Enum.with_index()

        start =
          cond do
            (s = Enum.find_index(cols, fn {c, _} -> c == "S" end)) || start_i == -1 -> [i, s]
            true -> [start_i, start_j]
          end

        {Enum.reduce(cols, map, fn {c, j}, acc -> Map.put(acc, [i, j], c) end), start}
    end
  end

  def loop({map, start}) do
    loops =
      find_starts(map, start)
      |> Enum.map(fn s -> find_loop(map, start, start, s, [start]) end)
      |> Enum.sort(&(length(&1) >= length(&2)))

    loops |> hd()
  end

  def find_loop(map, start, prev, curr, loop) do
    diff = diff_coord(prev, curr)

    next =
      @dir[map[curr]]
      |> Enum.reject(fn x -> x == diff end)
      |> hd()
      |> Enum.zip(curr)
      |> Enum.map(fn {m, n} -> m + n end)

    cond do
      is_nil(map[next]) or map[next] == "." -> []
      next == start -> loop ++ [curr] ++ [start]
      true -> find_loop(map, start, curr, next, loop ++ [curr])
    end
  end

  def diff_coord([i, j], [k, l]), do: [i - k, j - l]

  def find_starts(map, [start_i, start_j]) do
    for [i, j] <- @dir["S"], reduce: [] do
      acc ->
        cond do
          is_nil(map[[start_i + i, start_j + j]]) or map[[start_i + i, start_j + j]] == "." ->
            acc

          @dir[map[[start_i + i, start_j + j]]]
          |> Enum.any?(fn [k, l] -> [k, l] == [i, j] end) ->
            acc ++ [[start_i + i, start_j + j]]

          true ->
            acc
        end
    end
  end

  # shoelace algorithm to find area of the closed loop (trapezoid)
  # https://en.wikipedia.org/wiki/Shoelace_formula
  # note for rhis shoelace implementation we need xn == x0
  def shoelace(points) do
    Enum.chunk_every(points, 2, 1, :discard)
    |> Enum.reduce(0, fn [[x1, y1], [x2, y2]], acc -> acc + (y1 + y2) * (x2 - x1) end)
    |> div(2)
  end
end
