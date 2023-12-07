defmodule Aoc2023.Day4 do
  def etl_input(part),
    do:
      Aoc2023.day_from_module(__MODULE__)
      |> Aoc2023.read_input(part)
      |> process()
      |> count_matching()

  def part1(part \\ :ex1) do
    etl_input(part)
    |> Enum.filter(fn {_id, count} -> count != 0 end)
    |> Enum.reduce(0, fn {_id, count}, acc -> acc + 2 ** (count - 1) end)
  end

  def part2(part \\ :ex2) do
    etl_input(part)
    |> copies()
    |> make_points(1)
    |> Map.values()
    |> Enum.map(fn x -> x[:copies] end)
    |> Enum.sum()
  end

  def process(input) do
    for line <- input, reduce: %{} do
      acc ->
        [card_id, cards] = Regex.run(~r/Card\s+(\d+):\s+(.*)/, line, capture: :all_but_first)
        [winning, tickets] = String.split(cards, "|")

        Map.put(acc, String.to_integer(card_id), [
          split_numbers(winning),
          split_numbers(tickets)
        ])
    end
  end

  def split_numbers(list) do
    list |> String.split(" ", trim: true) |> Enum.map(&String.to_integer/1) |> MapSet.new()
  end

  def copies(cards) do
    for id <- Map.keys(cards), reduce: cards do
      acc ->
        Map.update!(acc, id, fn count -> %{:win => count, :copies => 1} end)
    end
  end

  def count_matching(cards) do
    for {id, numbers} <- cards, reduce: %{} do
      acc ->
        [winning, tickets] = numbers
        Map.put(acc, id, MapSet.intersection(winning, tickets) |> MapSet.size())
    end
  end

  def make_points(cards, current) when current >= map_size(cards) do
    cards
  end

  def make_points(cards, current) do
    win = cards[current][:win]

    for i <- (current + 1)..(current + win)//1, i <= map_size(cards), reduce: cards do
      acc ->
        update_in(acc[i][:copies], fn x -> x + acc[current][:copies] end)
    end
    |> make_points(current + 1)
  end
end
