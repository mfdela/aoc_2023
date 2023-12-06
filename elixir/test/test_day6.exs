defmodule Aoc2023Test.Day6 do
  use ExUnit.Case

  test "day6_part1_ex" do
    assert Aoc2023.Day6.part1(:ex1) == 288
  end

  test "day6_part1" do
    assert Aoc2023.Day6.part1(:input) == 140_220
  end

  test "day6_part2_ex" do
    assert Aoc2023.Day6.part2(:ex2) == 71503
  end

  test "day6_part2" do
    assert Aoc2023.Day6.part2(:input) == 39_570_185
  end
end
