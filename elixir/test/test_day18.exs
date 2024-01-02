defmodule Aoc2023Test.Day18 do
  use ExUnit.Case

  test "day18_part1_ex" do
    assert Aoc2023.Day18.part1(:ex1) == 62
  end

  test "day18_part1" do
    assert Aoc2023.Day18.part1(:input) == 52035
  end

  test "day18_part2_ex" do
    assert Aoc2023.Day18.part2(:ex2) == 952_408_144_115
  end

  test "day18_part2" do
    assert Aoc2023.Day18.part2(:input) == 60_612_092_439_765
  end
end
