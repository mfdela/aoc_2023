defmodule Aoc2023.Day9 do
  def etl_input(part),
    do: Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part) |> process()

  def part1(part \\ :ex1) do
    for l <- etl_input(part), reduce: 0 do
      acc ->
        acc + (differences(l, [l]) |> predict())
    end
  end

  def part2(part \\ :ex2) do
    for l <- etl_input(part), reduce: 0 do
      acc ->
        r = Enum.reverse(l)
        acc + (differences(r, [r]) |> predict())
    end
  end

  def process(input) do
    for line <- input do
      line |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1)
    end
  end

  def differences(list, list_of_diff) do
    if Enum.all?(list, &(&1 == 0)) do
      list_of_diff
    else
      diff =
        for [n1, n2] <- Enum.chunk_every(list, 2, 1) do
          n2 - n1
        end

      differences(diff, list_of_diff ++ [diff])
    end
  end

  def predict(list_of_diff) do
    # we don't need the [0, 0, ... 0] array
    [_ | rest] = Enum.reverse(list_of_diff)
    Enum.reduce(rest, 0, &(&2 + List.last(&1)))
  end
end
