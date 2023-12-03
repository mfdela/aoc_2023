defmodule Aoc2023.Day2 do
  def part1(part \\ :ex1) do
    input = Aoc2023.read_input("day2", part)
    # rgb
    conf = %{:red => 12, :green => 13, :blue => 14}
    process1(input, conf)
  end

  def part2(part \\ :ex2) do
    input = Aoc2023.read_input("day2", part)
    process2(input)
  end

  def process1(input, conf) do
    for s <- input, reduce: 0 do
      acc ->
        [gameid, comb] = Regex.run(~r/Game\s+(\d+):\s+(.*)/, s, capture: :all_but_first)
        games = String.split(comb, ";")

        valid =
          for game <- games, reduce: true do
            acc ->
              [r] = Regex.run(~r/(\d+)\s+red/, game, capture: :all_but_first) || ["0"]
              [g] = Regex.run(~r/(\d+)\s+green/, game, capture: :all_but_first) || ["0"]
              [b] = Regex.run(~r/(\d+)\s+blue/, game, capture: :all_but_first) || ["0"]

              cond do
                String.to_integer(r) <= conf[:red] and
                  String.to_integer(g) <= conf[:green] and
                  String.to_integer(b) <= conf[:blue] and acc ->
                  true

                true ->
                  false
              end
          end

        case valid do
          true ->
            acc + String.to_integer(gameid)

          false ->
            acc
        end
    end
  end

  def process2(input) do
    for s <- input, reduce: 0 do
      acc ->
        [gameid, comb] = Regex.run(~r/Game\s+(\d+):\s+(.*)/, s, capture: :all_but_first)
        games = String.split(comb, ";")

        min_set =
          for game <- games, reduce: [0, 0, 0] do
            acc ->
              [min_r, min_g, min_b] = acc
              [r] = Regex.run(~r/(\d+)\s+red/, game, capture: :all_but_first) || ["0"]
              [g] = Regex.run(~r/(\d+)\s+green/, game, capture: :all_but_first) || ["0"]
              [b] = Regex.run(~r/(\d+)\s+blue/, game, capture: :all_but_first) || ["0"]

              new_r =
                cond do
                  String.to_integer(r) > min_r ->
                    String.to_integer(r)

                  true ->
                    min_r
                end

              new_g =
                cond do
                  String.to_integer(g) > min_g ->
                    String.to_integer(g)

                  true ->
                    min_g
                end

              new_b =
                cond do
                  String.to_integer(b) > min_b ->
                    String.to_integer(b)

                  true ->
                    min_b
                end

              [new_r, new_g, new_b]
          end

        acc + Enum.reduce(min_set, 1, fn x, acc -> x * acc end)
    end
  end
end
