defmodule Aoc2023Test.Day9 do
  use ExUnit.Case

  test "day9_part1_ex" do
    assert Aoc2023.Day9.part1(:ex1) == 114
  end

  test "day9_part1" do
    assert Aoc2023.Day9.part1(:input) == 1_681_758_908
  end

  test "day9_part2_ex" do
    assert Aoc2023.Day9.part2(:ex2) == 2
  end

  test "day9_part2" do
    assert Aoc2023.Day9.part2(:input) == 803
  end
end
