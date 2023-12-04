defmodule Aoc2023Test.Day3 do
  use ExUnit.Case

  test "day3_part1_ex" do
    assert Aoc2023.Day3.part1(:ex1) == 4361
  end

  test "day3_part1" do
    assert Aoc2023.Day3.part1(:input) == 536_202
  end

  test "day3_part2_ex" do
    assert Aoc2023.Day3.part2(:ex2) == 467_835
  end

  test "day3_part2" do
    assert Aoc2023.Day3.part2(:input) == 78_272_573
  end
end
