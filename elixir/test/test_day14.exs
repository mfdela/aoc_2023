defmodule Aoc2023Test.Day14 do
  use ExUnit.Case

  test "day14_part1_ex" do
    assert Aoc2023.Day14.part1(:ex1) == 136
  end

  test "day14_part1" do
    assert Aoc2023.Day14.part1(:input) == 110_821
  end

  test "day14_part2_ex" do
    assert Aoc2023.Day14.part2(:ex2) == 64
  end

  test "day14_part2" do
    assert Aoc2023.Day14.part2(:input) == 83516
  end
end
