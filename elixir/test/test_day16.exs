defmodule Aoc2023Test.Day16 do
  use ExUnit.Case

  test "day16_part1_ex" do
    assert Aoc2023.Day16.part1(:ex1) == 46
  end

  test "day16_part1" do
    assert Aoc2023.Day16.part1(:input) == 7482
  end

  test "day16_part2_ex" do
    assert Aoc2023.Day16.part2(:ex2) == 51
  end

  test "day16_part2" do
    assert Aoc2023.Day16.part2(:input) == 7896
  end
end
