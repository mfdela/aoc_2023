defmodule Aoc2023Test.Day13 do
  use ExUnit.Case

  test "day13_part1_ex" do
    assert Aoc2023.Day13.part1(:ex1) == 405
  end

  test "day13_part1" do
    assert Aoc2023.Day13.part1(:input) == 27664
  end

  test "day13_part2_ex" do
    assert Aoc2023.Day13.part2(:ex2) == 400
  end

  test "day13_part2" do
    assert Aoc2023.Day13.part2(:input) == 33991
  end
end
