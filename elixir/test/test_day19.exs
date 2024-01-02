defmodule Aoc2023Test.Day19 do
  use ExUnit.Case

  test "day19_part1_ex" do
    assert Aoc2023.Day19.part1(:ex1) == 19114
  end

  test "day19_part1" do
    assert Aoc2023.Day19.part1(:input) == 319295
  end

  test "day19_part2_ex" do
    assert Aoc2023.Day19.part2(:ex2) == 167409079868000
  end

  test "day19_part2" do
    assert Aoc2023.Day19.part2(:input) == 110807725108076
  end
end
