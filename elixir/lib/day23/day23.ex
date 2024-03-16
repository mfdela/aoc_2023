defmodule Aoc2023.Day23 do
  @delta %{
    ">" => [{0, 1}],
    "^" => [{-1, 0}],
    "<" => [{0, -1}],
    "v" => [{1, 0}]
  }

  def etl_input(part, icy) do
    Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part) |> process(icy)
  end

  def part1(part \\ :ex1) do
    {g, start_tile, end_tile} = etl_input(part, true)

    (Graph.Pathfinding.all(g, start_tile, end_tile)
     |> Enum.map(&length/1)
     |> Enum.max()) - 1
  end

  def part2(part \\ :ex2) do
    {g, start_tile, end_tile} = etl_input(part, false)

    (Graph.Pathfinding.all(g, start_tile, end_tile)
     |> Enum.map(&length/1)
     |> Enum.max()) - 1
  end

  def process(input, icy) do
    map =
      input
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, r} ->
        row
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reject(fn {x, _} -> x == "#" end)
        |> Enum.map(fn {val, c} -> {{r, c}, val} end)
      end)
      |> Map.new()

    {dim_r, _} = Aoc2023.map_bounds(map)
    {start_tile, _} = Enum.find(map, fn {{r, _}, _} -> r == 0 end)
    {end_tile, _} = Enum.find(map, fn {{r, _}, _} -> r == dim_r end)

    graph =
      for u <- Map.keys(map), reduce: Graph.new(type: :directed) do
        acc ->
          find_neigh(map, u, icy)
          |> Enum.reduce(acc, fn v, g ->
            cond do
              icy == true and map[u] != "." -> Graph.add_edge(g, v, u)
              true -> g
            end
            |> Graph.add_edge(u, v)
          end)
      end

    {graph, start_tile, end_tile}
  end

  def find_neigh(mat, _u = {r, c}, icy) do
    cond do
      icy == true and mat[{r, c}] != "." -> @delta[mat[{r, c}]]
      true -> [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
    end
    |> Enum.map(fn {x, y} -> {x + r, y + c} end)
    |> Enum.filter(fn v -> is_map_key(mat, v) end)
  end
end
