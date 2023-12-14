defmodule Aoc2023 do
  @moduledoc """
  Documentation for `Aoc2023`.
  """

  def day_from_module(module_name) do
    module_name
    |> Atom.to_string()
    |> String.split(".")
    |> List.last()
    |> String.downcase()
  end

  def read_input_raw(day, part \\ :ex1) do
    case part do
      :ex1 -> File.read!("../input/#{day}/example1.txt")
      :ex2 -> File.read!("../input/#{day}/example2.txt")
      _ -> File.read!("../input/#{day}/input.txt")
    end
  end

  def read_input(day, part \\ :ex1) do
    Aoc2023.read_input_raw(day, part) |> String.split("\n", trim: true)
  end
end
