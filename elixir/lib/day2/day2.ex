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
              colours =
                Regex.named_captures(
                  ~r/(?=.*\b(?<red>\d+)\s+red\b)?(?=.*\b(?<blue>\d+)\s+blue\b)?(?=.*\b(?<green>\d+)\s+green\b)?.*/,
                  game
                )
                |> clean_map_colours()

              cond do
                colours[:red] <= conf[:red] and
                  colours[:green] <= conf[:green] and
                  colours[:blue] <= conf[:blue] and acc ->
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
          for game <- games, reduce: %{:red => 0, :green => 0, :blue => 0} do
            acc ->
              colours =
                Regex.named_captures(
                  ~r/(?=.*\b(?<red>\d+)\s+red\b)?(?=.*\b(?<blue>\d+)\s+blue\b)?(?=.*\b(?<green>\d+)\s+green\b)?.*/,
                  game
                )
                |> clean_map_colours()

              for c <- [:red, :green, :blue], reduce: acc do
                acc ->
                  cond do
                    colours[c] > acc[c] ->
                      Map.put(acc, c, colours[c])

                    true ->
                      acc
                  end
              end
          end

        acc + Enum.reduce(min_set, 1, fn {_, v}, acc -> v * acc end)
    end
  end

  defp clean_map_colours(map) do
    for {c, v} <- map, reduce: %{} do
      acc ->
        case v do
          "" -> Map.put(acc, String.to_atom(c), 0)
          _ -> Map.put(acc, String.to_atom(c), String.to_integer(v))
        end
    end
  end
end
