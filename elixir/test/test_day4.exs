defmodule Aoc2023Test.Day4 do
  use ExUnit.Case

  test "day4_part1_ex" do
    assert Aoc2023.Day4.part1(:ex1) == 13
  end

  test "day4_part1" do
    assert Aoc2023.Day4.part1(:input) == 25231
  end

  test "day4_part2_ex" do
    assert Aoc2023.Day4.part2(:ex2) == 30
  end

  test "day4_part2" do
    assert Aoc2023.Day4.part2(:input) == 9_721_255
  end
end
