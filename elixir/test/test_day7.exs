defmodule Aoc2023Test.Day7 do
  use ExUnit.Case

  test "day7_part1_ex" do
    assert Aoc2023.Day7.part1(:ex1) == 6440
  end

  test "day7_part1" do
    assert Aoc2023.Day7.part1(:input) == 250_120_186
  end

  test "day7_part2_ex" do
    assert Aoc2023.Day7.part2(:ex2) == 5905
  end

  test "day7_part2" do
    assert Aoc2023.Day7.part2(:input) == 250_665_248
  end
end
