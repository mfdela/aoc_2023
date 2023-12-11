defmodule Aoc2023Test.Day10 do
  use ExUnit.Case

  test "day10_part1_ex" do
    assert Aoc2023.Day10.part1(:ex1) == 8
  end

  test "day10_part1" do
    assert Aoc2023.Day10.part1(:input) == 7086
  end

  test "day10_part2_ex" do
    assert Aoc2023.Day10.part2(:ex2) == 4
  end

  test "day10_part2" do
    assert Aoc2023.Day10.part2(:input) == 317
  end
end
