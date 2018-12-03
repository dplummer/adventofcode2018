defmodule Day3Part2Test do
  use ExUnit.Case, async: true

  alias Mix.Tasks.Day3.Part2

  test "sample" do
    input = "#1 @ 1,3: 4x4
#2 @ 3,1: 4x4
#3 @ 5,5: 2x2"

    assert 3 == Part2.find_non_overlapping_claim(input)
  end
end
