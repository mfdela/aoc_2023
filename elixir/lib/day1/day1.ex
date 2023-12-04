defmodule Aoc2023.Day1 do
  def part1(part \\ :ex1) do
    input = Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part)

    process(input, false)
  end

  def part2(part \\ :ex2) do
    input = Aoc2023.day_from_module(__MODULE__) |> Aoc2023.read_input(part)
    process(input, true)
  end

  def process(input, letter_digits \\ false) do
    for s <- input, reduce: 0 do
      acc ->
        str =
          case letter_digits do
            false ->
              s

            true ->
              find_letter_digits(s)
          end

        acc +
          (Regex.replace(~r/[^\d]/, str, "", global: true)
           |> first_last()
           |> String.to_integer())
    end
  end

  def first_last(str), do: "#{String.slice(str, 0..0)}#{String.slice(str, -1..-1)}"

  def find_letter_digits(str) do
    digits = %{
      "one" => "on1ne",
      "two" => "tw2wo",
      "three" => "thr3ree",
      "four" => "fou4our",
      "five" => "fiv5ive",
      "six" => "si6ix",
      "seven" => "sev7ven",
      "eight" => "eig8ght",
      "nine" => "nin9ine"
    }

    for {s, d} <- digits, reduce: str do
      acc ->
        Regex.replace(~r/#{s}/, acc, d)
    end
  end
end
