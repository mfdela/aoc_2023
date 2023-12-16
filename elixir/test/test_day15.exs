defmodule Aoc2023Test.Day15 do
  use ExUnit.Case

  test "day15_part1_ex" do
    assert Aoc2023.Day15.part1(:ex1) == 1320
  end

  test "day15_part1" do
    assert Aoc2023.Day15.part1(:input) == 519_041
  end

  test "day15_part2_ex" do
    assert Aoc2023.Day15.part2(:ex2) == 145
  end

  test "day15_part2" do
    assert Aoc2023.Day15.part2(:input) == 260_530
  end
end
