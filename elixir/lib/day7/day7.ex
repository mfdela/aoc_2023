defmodule Aoc2023.Day7 do
  @cards1 ["A", "K", "Q", "J", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
          |> Enum.with_index()
          |> Map.new()
  @cards2 ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2", "J"]
          |> Enum.with_index()
          |> Map.new()

  def etl_input(part),
    do: Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part) |> process()

  def part1(part \\ :ex1) do
    hands = etl_input(part)

    hands
    |> sort_hands(1)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {hand, index}, acc -> acc + hands[hand] * (index + 1) end)
  end

  def part2(part \\ :ex2) do
    hands = etl_input(part)

    hands
    |> sort_hands(2)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {hand, index}, acc -> acc + hands[hand] * (index + 1) end)
  end

  def process(input) do
    for line <- input, reduce: %{} do
      acc ->
        [hand, bid] = String.split(line, " ", trim: true)
        Map.put(acc, hand, String.to_integer(bid))
    end
  end

  def sort_hands(input, part) do
    input |> Map.keys() |> Enum.sort(&compare(&1, &2, part))
  end

  def compare(hand1, hand2, part) do
    [v1, v2] = Enum.map([hand1, hand2], &hand_value(&1, part))

    cond do
      v1 == v2 -> compare_cards(hand1, hand2, part)
      true -> v1 < v2
    end
  end

  def compare_cards(hand1, hand2, part) do
    # return true if hand1 < hand2
    [cards1, cards2] = Enum.map([hand1, hand2], &String.split(&1, "", trim: true))

    for {c1, index} <- Enum.with_index(cards1), reduce: nil do
      acc ->
        c2 = Enum.at(cards2, index)

        cond do
          not is_nil(acc) -> acc
          c1 == c2 -> nil
          true -> compare_card(c1, c2, part)
        end
    end
  end

  def compare_card(c1, c2, part) do
    # c1 is higher than c2
    case part do
      1 -> @cards1[c1] > @cards1[c2]
      2 -> @cards2[c1] > @cards2[c2]
    end
  end

  def hand_value(hand, part) do
    freq = Enum.frequencies(hand |> String.split("", trim: true))

    distrib =
      cond do
        part == 1 or (part == 2 and is_nil(freq["J"])) ->
          freq |> Map.values() |> Enum.sort()

        part == 2 ->
          new_d = Map.delete(freq, "J") |> Map.values() |> Enum.sort()

          cond do
            # cover combinations [1, 4], [2, 3], []
            length(new_d) == 1 or length(new_d) == 0 ->
              [5]

            # cover combinations [1, 1, 1], [1, 1, 2]
            length(new_d) == 3 ->
              [1, 1, 3]

            # cover combinations [1, 1, 1, 1]
            length(new_d) == 4 ->
              [1, 1, 1, 2]

            # combination [2, 2]
            new_d == [2, 2] ->
              [2, 3]

            # cover combinations [1, 3], [1, 1], [1, 2], [2, 2]
            length(new_d) == 2 ->
              [1, 4]
          end
      end

    case distrib do
      # 5 of a kind
      [5] -> 6
      # 4 of kind
      [1, 4] -> 5
      # full house
      [2, 3] -> 4
      # 3 of a kind
      [1, 1, 3] -> 3
      # two pairs
      [1, 2, 2] -> 2
      # one pair ->
      [1, 1, 1, 2] -> 1
      # high card
      [1, 1, 1, 1, 1] -> 0
    end
  end
end
