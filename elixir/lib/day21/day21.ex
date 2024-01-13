defmodule Aoc2023.Day21 do
  def etl_input(part) do
    Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part) |> process()
  end

  def part1(part \\ :ex1) do
    {map, start, dim} = etl_input(part)

    Stream.iterate(MapSet.new([start]), &step(&1, map, dim))
    |> Stream.map(&MapSet.size/1)
    |> Enum.at(64)
  end

  def part2(part \\ :ex2) do
    {map, start, dim} = etl_input(part)
    {max_r, max_c} = dim
    if max_r != max_c, do: exit(:impossible_input)

    reach =
      Stream.iterate(MapSet.new([start]), &step(&1, map, dim))
      |> Stream.map(&MapSet.size/1)

    Stream.iterate(0, &(&1 + 1))
    |> Stream.map(&{&1, div(max_r + 1, 2) + &1 * (max_r + 1)})
    |> Stream.map(fn {i, steps} -> {i, Enum.at(reach, steps)} end)
    |> Enum.take(3)
    |> then(fn r -> lagrange(r, 202_300) end)
  end

  def process(input) do
    map =
      input
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, r} ->
        row
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {val, c} -> {{r, c}, val} end)
      end)
      |> Map.new()

    {start, _} = Enum.find(map, fn {_, v} -> v == "S" end)

    rocks =
      map
      |> Enum.filter(fn {_, v} -> v == "#" end)
      |> IO.inspect()
      |> MapSet.new(&elem(&1, 0))

    {rocks, start, Aoc2023.map_bounds(map)}
  end

  def step(reached, map, dim) do
    for {r, c} <- reached,
        {dr, dc} <- [{-1, 0}, {1, 0}, {0, 1}, {0, -1}],
        p = valid_pos({r + dr, c + dc}, dim, map),
        reduce: MapSet.new() do
      acc ->
        MapSet.put(acc, p)
    end
  end

  def valid_pos(p = {r, c}, {max_r, max_c}, map) do
    # note. Fails on the example since we will go past the borders. Doesn't happen in the real input
    in_p = {mod(r, max_r + 1), mod(c, max_c + 1)}

    cond do
      MapSet.member?(map, in_p) -> false
      true -> p
    end
  end

  def mirrored_pos({r, c}, {max_r, max_c}) do
    {mod(r, max_r + 1), mod(c, max_c + 1)}
  end

  def mod(a, b) do
    cond do
      a > 0 -> rem(a, b)
      a == 0 -> 0
      a < 0 -> b + rem(a, b)
    end
  end

  def lagrange([{x0, y0}, {x1, y1}, {x2, y2}], x) do
    t0 = div((x - x1) * (x - x2), (x0 - x1) * (x0 - x2)) * y0
    t1 = div((x - x0) * (x - x2), (x1 - x0) * (x1 - x2)) * y1
    t2 = div((x - x0) * (x - x1), (x2 - x0) * (x2 - x1)) * y2
    t0 + t1 + t2
  end
end
