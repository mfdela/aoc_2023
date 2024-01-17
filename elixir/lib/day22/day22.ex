defmodule Aoc2023.Day22 do
  def etl_input(part) do
    Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part) |> process()
  end

  def part1(part \\ :ex1) do
    etl_input(part)
    |> drop()
    |> support()
    |> then(fn supported ->
      list = map_size(supported)
      supporting = supported |> supporting() |> length()
      list - supporting
    end)
  end

  def part2(part \\ :ex2) do
    list =
      etl_input(part)
      |> drop()

    supports = all_supporting(list)
    supported =  supported(list)
    supported
    |> supporting()
    |> Enum.map(&removal(&1, supported, supports))
    |> Enum.sum()
  end

  def process(input) do
    input
    |> Enum.map(fn line ->
      ~r/(\d+),(\d+),(\d+)~(\d+),(\d+),(\d+)/
      |> Regex.run(line, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)
      |> then(fn [x1, y1, z1, x2, y2, z2] -> {x1..x2, y1..y2, z1..z2} end)
    end)
    |> List.keysort(2)
  end

  def drop(list), do: list |> Enum.reduce({[], %{}}, &drop/2) |> elem(0) |> List.keysort(2)

  def drop({range_x, range_y, z1..z2}, {dropped, cache}) do
    lowest_z = Enum.max(for(x <- range_x, y <- range_y, do: Map.get(cache, {x, y}, 0))) + 1
    t = {range_x, range_y, lowest_z..(lowest_z + (z2 - z1))}
    {[t | dropped], update_cache(cache, t)}
  end

  def update_cache(cache, {range_x, range_y, range_z}) do
    for(x <- range_x, y <- range_y, z <- range_z, do: {x, y, z})
    |> Enum.reduce(cache, fn {x, y, z}, cache ->
      Map.update(cache, {x, y}, z, fn prev_z -> max(z, prev_z) end)
    end)
  end

  def support(list), do: list |> Enum.map(&{&1, support(&1, list)}) |> Map.new()
  def support(l, list), do: Enum.filter(list, &supports?(&1, l))

  def supports?({x1, y1, _..z1}, {x2, y2, z2.._}) do
    z1 == z2 - 1 and not Range.disjoint?(x1, x2) and not Range.disjoint?(y1, y2)
  end

  def supporting(supported) do
    supported
    |> Map.values()
    |> Enum.filter(&(length(&1) == 1))
    |> Enum.map(&hd/1)
    |> Enum.uniq()
  end

  def all_supporting(list), do: list |> Enum.map(&{&1, all_supporting(&1, list)}) |> Map.new()
  def all_supporting(l, list), do: Enum.filter(list, &supports?(l, &1))

  def supported(list), do: list |> Enum.map(&{&1, supported(&1, list)}) |> Map.new()
  def supported(l, list), do: Enum.filter(list, &supports?(&1, l))

  def removal(l, supported, supports) do
    removal(Qex.new([l]), 0, supported, supports)
  end

  def removal(queue, count, supported, supports) do
    if Enum.empty?(queue) do
      count
    else
      {to_remove, queue} = Qex.pop!(queue)
      lost_support = Map.get(supports, to_remove, [])

      supported =
        Enum.reduce(lost_support, supported, fn el, supported ->
          Map.update!(supported, el, &List.delete(&1, to_remove))
        end)

      unsupported = Enum.filter(lost_support, &(supported[&1] == []))

      removal(
        Qex.join(queue, Qex.new(unsupported)),
        count + length(unsupported),
        supported,
        supports
      )
    end
  end
end
