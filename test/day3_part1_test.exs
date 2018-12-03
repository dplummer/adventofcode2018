defmodule Day3Part1Test do
  use ExUnit.Case, async: true

  alias Mix.Tasks.Day3.Part1

  test "sample" do
    input = "#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2"

    assert 4 == Part1.count_overlapping_claims(input)
  end

  test "parse_line" do
    assert {1, 1, 3, 4, 4} = Part1.parse_line("#1 @ 1,3: 4x4")
    assert {123, 100, 33, 488, 5015} = Part1.parse_line("#123 @ 100,33: 488x5015")
  end
end
