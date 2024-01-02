defmodule Aoc2023.Day18 do
  @dir %{"R" => [0, 1], "L" => [0, -1], "U" => [-1, 0], "D" => [1, 0]}
  @dir_2 %{"0" => "R", "2" => "L", "3" => "U", "1" => "D"}

  def etl_input(part) do
    Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part) |> process()
  end

  def part1(part \\ :ex1) do
    etl_input(part)
    |> Enum.map(fn [d, amount, _, _] -> [d, String.to_integer(amount)] end)
    |> compute_internal_points()
  end

  def part2(part \\ :ex2) do
    etl_input(part)
    |> Enum.map(fn [_, _, amount, d] ->
      [@dir_2[d], Integer.parse(amount, 16) |> then(fn {a, _} -> a end)]
    end)
    |> compute_internal_points()
  end

  def process(input) do
    input
    |> Enum.map(&Regex.run(~r/^(\w)\s+(\d+)\s+\(#(\w{5})(\w)/, &1, capture: :all_but_first))
  end

  def compute_internal_points(list) do
    {boundary, length} =
      Enum.reduce(list, {[[0, 0]], 0}, fn [d, amount], acc ->
        {points, length} = acc

        {points ++
           [multiply(@dir[d], amount) |> Enum.zip(List.last(points)) |> Enum.map(&Tuple.sum/1)],
         length + amount}
      end)

    # remove duplicate starting point
    [_ | points] = boundary
    abs(shoelace(points)) - div(length, 2) + 1 + length
  end

  def multiply([r, c], amount) do
    [r * amount, c * amount]
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
