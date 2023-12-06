defmodule Aoc2023.Day6 do
  def part1(part \\ :ex1) do
    Aoc2023.day_from_module(__MODULE__)
    |> Aoc2023.read_input(part)
    |> process()
    |> race_wins()
  end

  def part2(part \\ :ex2) do
    Aoc2023.day_from_module(__MODULE__)
    |> Aoc2023.read_input(part)
    |> process()
    |> Enum.map(&Enum.join/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(fn x -> [x] end)
    |> race_wins()
  end

  def process(input) do
    for line <- input, reduce: [[], []] do
      acc ->
        [time, distance] = acc

        cond do
          Regex.match?(~r/^Time:/, line) ->
            [
              Regex.scan(~r/\b(\d+)\b/, line)
              |> Enum.map(&hd/1)
              |> Enum.map(&String.to_integer/1),
              distance
            ]

          Regex.match?(~r/^Distance:/, line) ->
            [
              time,
              Regex.scan(~r/\b(\d+)\b/, line) |> Enum.map(&hd/1) |> Enum.map(&String.to_integer/1)
            ]
        end
    end
  end

  def race_wins([time, distance]) do
    for {t, index} <- Enum.with_index(time), reduce: 1 do
      acc ->
        d = Enum.at(distance, index)
        # total time of race = t_hold + (T - t_hold) [ms]
        # travel time t_travel = (T - t_hold) [ms]
        # speed = t_hold [mm/ms]
        # distance = speed * t_travel = t_hold * (T - hold)
        # t_hold * (T - hold) > S, t_hold < T
        # -t_h^2 + t_h * T -S > 0, t_hold < T
        first_sol = floor((t - :math.sqrt(t * t - 4 * d)) / 2.0)
        second_sol = ceil((t + :math.sqrt(t * t - 4 * d)) / 2.0)

        acc * Enum.max([second_sol - first_sol - 1, 0])
    end
  end
end
