defmodule Aoc2023Test.Day23 do
  use ExUnit.Case

  test "day23_part1_ex" do
    assert Aoc2023.Day23.part1(:ex1) == 94
  end

  test "day23_part1" do
    assert Aoc2023.Day23.part1(:input) == 2442
  end

  test "day23_part2_ex" do
    assert Aoc2023.Day23.part2(:ex2) == 154
  end

  @tag timeout: :infinity
  test "day23_part2" do
    assert Aoc2023.Day23.part2(:input) == 6898
  end
end
