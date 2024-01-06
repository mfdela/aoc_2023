defmodule Aoc2023Test.Day20 do
  use ExUnit.Case

  test "day20_part1_ex" do
    assert Aoc2023.Day20.part1(:ex1) == 11687500
  end

  test "day20_part1" do
    assert Aoc2023.Day20.part1(:input) == 737679780
  end

  test "day20_part2" do
    assert Aoc2023.Day20.part2(:input) == 227411378431763
  end
end
