defmodule Aoc2023Test.Day11 do
  use ExUnit.Case

  test "day11_part1_ex" do
    assert Aoc2023.Day11.part1(:ex1) == 374
  end

  test "day11_part1" do
    assert Aoc2023.Day11.part1(:input) == 9_769_724
  end

  test "day11_part2_ex" do
    assert Aoc2023.Day11.part2(:ex2, 100) == 8410
  end

  test "day11_part2" do
    assert Aoc2023.Day11.part2(:input, 1_000_000) == 603_020_563_700
  end
end
