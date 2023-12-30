defmodule Aoc2023Test.Day17 do
  use ExUnit.Case

  test "day17_part1_ex" do
    assert Aoc2023.Day17.part1(:ex1) == 102
  end

  @tag timeout: :infinity
  test "day17_part1" do
    assert Aoc2023.Day17.part1(:input) == 1001
  end

  @tag timeout: :infinity
  test "day17_part2_ex" do
    assert Aoc2023.Day17.part2(:ex2) == 94
  end

  @tag timeout: :infinity
  test "day17_part2" do
    assert Aoc2023.Day17.part2(:input) == 1197
  end
end
