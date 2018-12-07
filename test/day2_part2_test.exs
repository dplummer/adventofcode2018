defmodule Day2Part2Test do
  use ExUnit.Case, async: true

  alias Mix.Tasks.Day2.Part2

  test "sample" do
    input =
      "abcde
fghij
klmno
pqrst
fguij
axcye
wvxyz"
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)

    assert "fgij" == Part2.find_lines(input, input)
  end
end
