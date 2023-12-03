defmodule Aoc2023 do
  @moduledoc """
  Documentation for `Aoc2023`.
  """

  def read_input(day, part \\ :ex1) do
    input =
      case part do
        :ex1 -> File.read!("../input/#{day}/example1.txt")
        :ex2 -> File.read!("../input/#{day}/example2.txt")
        _ -> File.read!("../input/#{day}/input.txt")
      end

    input |> String.split("\n", trim: true)
  end
end
