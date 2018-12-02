defmodule Day2Part1Test do
  use ExUnit.Case, async: true

  alias Mix.Tasks.Day2.Part1

  test "sample" do
    input = "abcdef
bababc
abbcde
abcccd
aabcdd
abcdee
ababab"

    assert 12 == Part1.checksum(input)
  end


  test "line_count" do
    assert {0,0} == Part1.line_count("abcdef")
    assert {1,1} == Part1.line_count("bababc")
    assert {1,0} == Part1.line_count("abbcde")
    assert {0,1} == Part1.line_count("abcccd")
    assert {1,0} == Part1.line_count("aabcdd")
    assert {1,0} == Part1.line_count("abcdee")
    assert {0,1} == Part1.line_count("ababab")
  end
end
