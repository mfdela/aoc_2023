defmodule Aoc2023.Day15 do
  def etl_input(part) do
    Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input_raw(part) |> process()
  end

  def part1(part \\ :ex1) do
    etl_input(part)
    |> sum1()
  end

  def part2(part \\ :ex2) do
    inst = etl_input(part)

    boxes =
      for i <- 0..255, reduce: Map.new() do
        acc ->
          Map.put(acc, i, [])
      end

    box_processing(inst, boxes)
    |> sum2()
  end

  def process(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
  end

  def sum1(input) do
    for inst <- input, reduce: 0 do
      acc ->
        acc + hash(inst)
    end
  end

  def hash(inst) do
    for c <- String.graphemes(inst), reduce: 0 do
      acc ->
        <<v::utf8>> = c
        rem((acc + v) * 17, 256)
    end
  end

  def box_processing(input, map) do
    for inst <- input, reduce: map do
      acc ->
        cond do
          String.contains?(inst, "=") ->
            [label, lens] = String.split(inst, "=", trim: true)
            box = hash(label)
            insert(acc, box, label, lens)

          String.contains?(inst, "-") ->
            label = String.trim(inst, "-")
            box = hash(label)
            delete(acc, box, label)
        end
    end
  end

  def insert(map, box, label, lens) do
    {found, lenses} =
      for {l, focal} <- map[box], reduce: {false, []} do
        acc ->
          {found, lenses} = acc

          cond do
            l == label -> {true, lenses ++ [{label, lens}]}
            true -> {found, lenses ++ [{l, focal}]}
          end
      end

    if found do
      Map.put(map, box, lenses)
    else
      Map.put(map, box, lenses ++ [{label, lens}])
    end
  end

  def delete(map, box, label) do
    new_box =
      map[box]
      |> Enum.reject(fn {l, _} -> l == label end)

    Map.put(map, box, new_box)
  end

  def sum2(map) do
    for i <- 0..255, reduce: 0 do
      acc ->
        lenses = Enum.with_index(map[i])

        acc +
          cond do
            lenses == [] ->
              0

            true ->
              for {{_, focal}, slot} <- lenses, reduce: 0 do
                inner_acc ->
                  inner_acc + (i + 1) * (slot + 1) * String.to_integer(focal)
              end
          end
    end
  end
end
