defmodule Aoc2023.Day3 do
  def etl_input(part),
    do: Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part) |> process()

  def part1(part \\ :ex1) do
    etl_input(part)
    |> find_part_numbers()
    |> Enum.sum()
  end

  def part2(part \\ :ex2) do
    etl_input(part)
    |> find_gears()
    |> Enum.sum()
  end

  def process(input) do
    for {line, line_num} <- Enum.with_index(input), reduce: {%{}, %{}} do
      acc ->
        numbers_symbols =
          Regex.scan(~r/(\d+)|([^\.\d]{1})/, line, return: :index) |> Enum.map(&hd/1)

        for {start, length} <- numbers_symbols, reduce: acc do
          acc ->
            extract = String.slice(line, start, length)
            {pos_to_number, symbol_to_pos} = acc

            case Integer.parse(extract) do
              {int, ""} ->
                new_pos =
                  for i <- 0..(length - 1), reduce: pos_to_number do
                    acc ->
                      Map.put(acc, {line_num, start + i}, {int, {line_num, start}})
                  end

                {new_pos, symbol_to_pos}

              :error ->
                {pos_to_number,
                 Map.update(symbol_to_pos, extract, [{line_num, start}], fn x ->
                   [{line_num, start} | x]
                 end)}
            end
        end
    end
  end

  def find_part_numbers({pos_to_number, symbol_to_pos}) do
    for {_, pos_list} <- symbol_to_pos, reduce: MapSet.new() do
      acc ->
        # register all the numbers that are adjacent to a symbol
        for pos <- pos_list, reduce: acc do
          acc -> MapSet.union(acc, adjacents(pos_to_number, pos))
        end
    end
    |> MapSet.to_list()
    |> Enum.map(fn {int, {_, _}} -> int end)
  end

  def find_gears({pos_to_number, symbol_to_pos}) do
    for {symbol, pos_list} <- symbol_to_pos, symbol == "*", reduce: [] do
      acc ->
        for pos <- pos_list, reduce: acc do
          acc ->
            adj = adjacents(pos_to_number, pos)

            case MapSet.size(adj) do
              2 ->
                [
                  adj
                  |> MapSet.to_list()
                  |> Enum.reduce(1, fn {int, {_, _}}, acc -> acc * int end)
                  | acc
                ]

              _ ->
                acc
            end
        end
    end
  end

  def adjacents(pos_to_number, {row, column}) do
    for i <- -1..1, j <- -1..1, reduce: MapSet.new() do
      acc ->
        case pos_to_number[{row + i, column + j}] do
          nil -> acc
          _ -> MapSet.put(acc, pos_to_number[{row + i, column + j}])
        end
    end
  end
end
