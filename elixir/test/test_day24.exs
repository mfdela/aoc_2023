defmodule Aoc2023Test.Day24 do
  use ExUnit.Case

  test "day24_part1_ex" do
    assert Aoc2023.Day24.part1(:ex1) == 2
  end

  test "day24_part1" do
    assert Aoc2023.Day24.part1(:input) == 13965
  end

  test "day24_part2_ex" do
    assert Aoc2023.Day24.part2(:ex2) == 47
  end

  test "day24_part2" do
    assert Aoc2023.Day24.part2(:input) == 578_177_720_733_043
  end
end
