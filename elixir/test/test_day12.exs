defmodule Aoc2023Test.Day12 do
  use ExUnit.Case

  test "day12_part1_ex" do
    assert Aoc2023.Day12.part1(:ex1) == 21
  end

  test "day12_part1" do
    assert Aoc2023.Day12.part1(:input) == 7025
  end

  test "day12_part2_ex" do
    assert Aoc2023.Day12.part2(:ex2) == 525_152
  end

  @tag timeout: :infinity
  test "day12_part2" do
    assert Aoc2023.Day12.part2(:input) == 11_461_095_383_315
  end
end
