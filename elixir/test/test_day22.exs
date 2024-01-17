defmodule Aoc2023Test.Day22 do
  use ExUnit.Case

  test "day22_part1_ex" do
    assert Aoc2023.Day22.part1(:ex1) == 5
  end

  test "day22_part1" do
    assert Aoc2023.Day22.part1(:input) == 473
  end

  test "day22_part2_ex" do
    assert Aoc2023.Day22.part2(:ex2) == 7
  end

  test "day22_part2" do
    assert Aoc2023.Day22.part2(:input) == 61045
  end
end
