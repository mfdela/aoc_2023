defmodule Aoc2023Test.Day8 do
  use ExUnit.Case

  test "day8_part1_ex" do
    assert Aoc2023.Day8.part1(:ex1) == 2
  end

  test "day8_part1" do
    assert Aoc2023.Day8.part1(:input) == 16271
  end

  test "day8_part2_ex" do
    assert Aoc2023.Day8.part2(:ex2) == 6
  end

  test "day8_part2" do
    assert Aoc2023.Day8.part2(:input) == 14_265_111_103_729
  end
end
