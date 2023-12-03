defmodule Aoc2023Test.Day1 do
  use ExUnit.Case

  test "day1_part1_ex" do
    assert Aoc2023.Day1.part1(:ex1) == 142
  end

  test "day1_part1" do
    assert Aoc2023.Day1.part1(:input) == 55208
  end

  test "day1_part2_ex" do
    assert Aoc2023.Day1.part2(:ex2) == 281
  end

  test "day1_part2" do
    assert Aoc2023.Day1.part2(:input) == 54578
  end
end
