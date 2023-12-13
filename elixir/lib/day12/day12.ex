defmodule Aoc2023.Day12 do
  use Agent

  def start do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def etl_input(part) do
    {:ok, _} = Aoc2023.Day12.start()
    Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part) |> process()
  end

  def part1(part \\ :ex1) do
    for [s, nums] <- etl_input(part), reduce: 0 do
      acc ->
        acc + count_arrangements(s, nums)
    end
  end

  def part2(part \\ :ex2) do
    for [s, nums] <- etl_input(part), reduce: 0 do
      acc ->
        s2 = List.duplicate([s], 5) |> Enum.join("?")
        nums2 = List.duplicate(nums, 5) |> List.flatten()
        acc + count_arrangements(s2, nums2)
    end
  end

  def process(input) do
    Enum.map(input, fn l ->
      [s, n] = String.split(l, " ")
      nums = String.split(n, ",") |> Enum.map(&String.to_integer/1)
      [s, nums]
    end)
  end

  def count_arrangements("", nums) do
    cond do
      nums == [] -> 1
      true -> 0
    end
  end

  def count_arrangements(s, []) do
    cond do
      String.contains?(s, "#") -> 0
      true -> 1
    end
  end

  def count_arrangements(s, nums) do
    key = {s, nums}

    cached_value = Agent.get(__MODULE__, &Map.get(&1, key))

    if cached_value do
      cached_value
    else
      c1 =
        if String.first(s) == "." or String.first(s) == "?" do
          count_arrangements(String.slice(s, 1..-1//1), nums)
        else
          0
        end

      c2 =
        if String.first(s) == "#" or String.first(s) == "?" do
          first_num = List.first(nums)

          if first_num <= String.length(s) and
               not (String.slice(s, 0..(first_num - 1)) |> String.contains?(".")) and
               (first_num == String.length(s) or String.at(s, first_num) != "#") do
            count_arrangements(
              String.slice(s, (first_num + 1)..-1//1),
              Enum.slice(nums, 1..-1//1)
            )
          else
            0
          end
        else
          0
        end

      Agent.update(__MODULE__, &Map.put(&1, key, c1 + c2))
      c1 + c2
    end
  end
end
