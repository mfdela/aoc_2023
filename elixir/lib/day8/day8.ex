defmodule Aoc2023.Day8 do
  def etl_input(part),
    do: Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part) |> process()

  def part1(part \\ :ex1) do
    etl_input(part)
    |> path("AAA", &(&1 == "ZZZ"))
  end

  def part2(part \\ :ex2) do
    {dir, map} = etl_input(part)

    for start <- map |> Map.keys() |> Enum.filter(&String.ends_with?(&1, "A")), reduce: 1 do
      acc ->
        lcm(acc, path({dir, map}, start, &String.ends_with?(&1, "Z")))
    end
  end

  def process(input) do
    [directions | nodes] = input

    map =
      for line <- nodes, reduce: %{} do
        acc ->
          [start, left, right] =
            Regex.run(~r/(\w\w\w)\s+=\s+\((\w\w\w),\s+(\w\w\w)\)/, line, capture: :all_but_first)

          Map.put(acc, start, %{"L" => left, "R" => right})
      end

    {directions |> String.graphemes() |> Stream.cycle(), map}
  end

  def path({directions, map}, start, target_end) do
    Enum.reduce_while(directions, {0, start}, fn dir, {steps, node} ->
      if target_end.(node) do
        {:halt, steps}
      else
        {:cont, {steps + 1, select_next(dir, map[node])}}
      end
    end)
  end

  def select_next(direction, node) do
    case direction do
      "L" -> node["L"]
      "R" -> node["R"]
    end
  end

  defp lcm(a, b, d \\ nil) do
    if b == 0 do
      div(d, a)
    else
      lcm(b, rem(a, b), d || a * b)
    end
  end
end
