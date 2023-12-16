defmodule Aoc2023 do
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

  def stream_input_raw(day, part \\ :ex1) do
    case part do
      :ex1 -> File.stream!("../input/#{day}/example1.txt", [], 1)
      :ex2 -> File.stream!("../input/#{day}/example2.txt", [], 1)
      _ -> File.stream!("../input/#{day}/input.txt", [], 1)
    end
  end

  def read_input(day, part \\ :ex1) do
    Aoc2023.read_input_raw(day, part) |> String.split("\n", trim: true)
  end

  def transpose(mat) do
    Enum.zip_with(mat, &Function.identity/1)
  end
end
