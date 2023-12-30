defmodule Aoc2023.Day17 do
  def etl_input(part) do
    Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part) |> process()
  end

  def part1(part \\ :ex1) do
    mat = etl_input(part)
    end_v = Aoc2023.map_bounds(mat)

    find_path(mat, {0, 0, 0, 0, 0}, end_v, end_v, 0, 3)
  end

  def part2(part \\ :ex2) do
    mat = etl_input(part)
    end_v = Aoc2023.map_bounds(mat)

    find_path(mat, {0, 0, 0, 0, 0}, end_v, end_v, 4, 10)
  end

  def process(input) do
    input
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, r} ->
      row
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.map(fn {val, c} -> {{r, c}, val} end)
    end)
    |> Map.new()
  end

  def find_path(mat, start_v, end_v, dim, n_min, n_max) do
    find_path(
      mat,
      end_v,
      PriorityQueue.new() |> PriorityQueue.push(Tuple.append(start_v, 0), 0),
      MapSet.new([]),
      dim,
      n_min,
      n_max
    )
  end

  def find_path(mat, end_v, queue, visited, dim, n_min, n_max) do
    {{:value, u}, pq} = PriorityQueue.pop(queue)
    {r, c, dr, d, n, cost} = u

    new_pq =
      cond do
        {r, c, dr, d, n} in visited ->
          pq

        true ->
          pq
          |> add_same_dir(mat, u, dim, n_max)
          |> add_all_dir(mat, u, dim, n_min)
      end

    cond do
      {r, c} == end_v and n >= n_min ->
        cost

      true ->
        find_path(
          mat,
          end_v,
          new_pq,
          MapSet.put(visited, {r, c, dr, d, n}),
          dim,
          n_min,
          n_max
        )
    end
  end

  def reject_out_of_bound(l, {n_rows, n_cols}) do
    Enum.reject(l, fn {x, y} -> x < 0 or y < 0 or x > n_rows or y > n_cols end)
  end

  def add_same_dir(queue, mat, _u = {r, c, dr, dc, n, cost}, dim, n_max)
      when n < n_max and {dr, dc} != {0, 0} do
    case [{r + dr, c + dc}] |> reject_out_of_bound(dim) do
      [] ->
        queue

      _ ->
        dist = cost + mat[{r + dr, c + dc}]
        PriorityQueue.push(queue, {r + dr, c + dc, dr, dc, n + 1, dist}, dist)
    end
  end

  def add_same_dir(queue, _mat, _u, _dim, _n_max), do: queue

  def add_all_dir(queue, mat, _u = {r, c, dr, dc, n, cost}, dim, n_min)
      when n >= n_min or {dr, dc} == {0, 0} do
    for {nr, nc} <-
          [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
          |> Enum.filter(fn {x, y} -> {x, y} != {dr, dc} and {x, y} != {-dr, -dc} end)
          |> Enum.map(fn {x, y} -> {x + r, y + c} end)
          |> reject_out_of_bound(dim),
        reduce: queue do
      acc ->
        dist = cost + mat[{nr, nc}]
        PriorityQueue.push(acc, {nr, nc, nr - r, nc - c, 1, dist}, dist)
    end
  end

  def add_all_dir(queue, _mat, _u, _dim, _n_min), do: queue
end
