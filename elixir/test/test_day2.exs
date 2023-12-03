defmodule Aoc2023Test.Day2 do
  use ExUnit.Case

  test "day2_part1_ex" do
    assert Aoc2023.Day2.part1(:ex1) == 8
  end

  test "day2_part1" do
    assert Aoc2023.Day2.part1(:input) == 2101
  end

  test "day2_part2_ex" do
    assert Aoc2023.Day2.part2(:ex2) == 2286
  end

  test "day2_part2" do
    assert Aoc2023.Day2.part2(:input) == 58269
  end
end
