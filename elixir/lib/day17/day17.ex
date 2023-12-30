defmodule Aoc2023.Day17 do
  def etl_input(part) do
    Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part) |> process()
  end

  def part1(part \\ :ex1) do
    mat = etl_input(part)
    end_v = Aoc2023.map_bounds(mat)

    find_path(mat, {0, 0, 0, 0, 0}, end_v, end_v, 1)
    |> then(fn {_q, d} -> d end)
    |> Enum.filter(fn {{r, c, _, _, _}, _val} -> {r, c} == end_v end)
    |> Enum.map(fn {_, val} -> val end)
    |> Enum.min()
  end

  def part2(part \\ :ex2) do
    mat = etl_input(part)
    end_v = Aoc2023.map_bounds(mat)

    find_path(mat, {0, 0, 0, 0, 0}, end_v, end_v, 2)
    |> then(fn {_q, d} -> d end)
    |> Enum.filter(fn {{r, c, _, _, n}, _val} -> {r, c} == end_v and n >= 4 end)
    |> Enum.map(fn {_, val} -> val end)
    |> Enum.min()
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

  def find_path(mat, start_v, end_v, dim, part) do
    find_path(mat, end_v, {[start_v], %{start_v => 0}}, MapSet.new([]), dim, part)
  end

  def find_path(_mat, _end_v, state = {[], _dist}, _visited, _dim, _part), do: state

  def find_path(mat, end_v, state = {queue, dist}, visited, dim, part) do
    u = Aoc2023.PrioQ.extract_min(queue, dist)
    {r, c, _, _, n} = u

    {new_queue, new_dist} =
      cond do
        u in visited ->
          {List.delete(queue, u), dist}

        part == 1 ->
          {List.delete(queue, u), dist}
          |> add_same_dir(mat, u, dim, 3)
          |> add_all_dir(mat, u, dim, 1)

        part == 2 ->
          {List.delete(queue, u), dist}
          |> add_same_dir(mat, u, dim, 10)
          |> add_all_dir(mat, u, dim, 2)
      end

    cond do
      {r, c} == end_v and part == 1 ->
        state

      {r, c} == end_v and n >= 4 and part == 2 ->
        state

      true ->
        find_path(
          mat,
          end_v,
          {new_queue, new_dist},
          MapSet.put(visited, u),
          dim,
          part
        )
    end
  end

  def reject_out_of_bound(l, {n_rows, n_cols}) do
    Enum.reject(l, fn {x, y} -> x < 0 or y < 0 or x > n_rows or y > n_cols end)
  end

  def add_same_dir(state = {queue, dist}, mat, u = {r, c, dr, dc, n}, dim, lim)
      when n < lim and {dr, dc} != {0, 0} do
    case [{r + dr, c + dc}] |> reject_out_of_bound(dim) do
      [] ->
        state

      _ ->
        {[{r + dr, c + dc, dr, dc, n + 1} | queue],
         Map.update(
           dist,
           {r + dr, c + dc, dr, dc, n + 1},
           dist[u] + mat[{r + dr, c + dc}],
           fn v ->
             cond do
               v < dist[u] + mat[{r + dr, c + dc}] -> v
               true -> dist[u] + mat[{r + dr, c + dc}]
             end
           end
         )}
    end
  end

  def add_same_dir(state, _mat, _u, _dim, _lim), do: state

  def add_all_dir(state, mat, u = {r, c, dr, dc, n}, dim, part)
      when part == 1 or (part == 2 and n >= 4) or (part == 2 and {dr, dc} == {0, 0}) do
    for {nr, nc} <-
          [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
          |> Enum.filter(fn {x, y} -> {x, y} != {dr, dc} and {x, y} != {-dr, -dc} end)
          |> Enum.map(fn {x, y} -> {x + r, y + c} end)
          |> reject_out_of_bound(dim),
        reduce: state do
      acc ->
        {q, d} = acc

        {[{nr, nc, nr - r, nc - c, 1} | q],
         Map.update(d, {nr, nc, nr - r, nc - c, 1}, d[u] + mat[{nr, nc}], fn v ->
           cond do
             v < d[u] + mat[{nr, nc}] -> v
             true -> d[u] + mat[{nr, nc}]
           end
         end)}
    end
  end

  def add_all_dir(state, _mat, _u, _dim, _part), do: state
end
