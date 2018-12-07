defmodule Mix.Tasks.Day2.Part2 do
  use Mix.Task

  @moduledoc """
  --- Part Two ---
  Confident that your list of box IDs is complete, you're ready to find the boxes full of prototype
  fabric.

  The boxes will have IDs which differ by exactly one character at the same position in both
  strings. For example, given the following box IDs:

  abcde
  fghij
  klmno
  pqrst
  fguij
  axcye
  wvxyz
  The IDs abcde and axcye are close, but they differ by two characters (the second and fourth).
  However, the IDs fghij and fguij differ by exactly one character, the third (h and u). Those must
  be the correct boxes.

  What letters are common between the two correct box IDs? (In the example above, this is found by
  removing the differing character from either ID, producing fgij.)
  """

  def run(_args) do
    Application.ensure_started(:adventofcode2018)

    Result.run(fn ->
      lines =
        File.read!("priv/day2_input.txt")
        |> String.split("\n")
        |> Enum.map(&String.graphemes/1)

      find_lines(lines, lines)
    end)
  end

  def find_lines([line1 | rest], lines) do
    line1
    |> compare(lines)
    |> case do
      nil ->
        find_lines(rest, lines)

      line2 ->
        Enum.zip([line1, line2])
        |> Enum.filter(fn
          {a, a} -> true
          _ -> false
        end)
        |> Enum.map(&elem(&1, 0))
        |> Enum.join("")
    end
  end

  def compare(line1, lines) do
    lines
    |> Enum.find(fn line2 ->
      length(line1) - 1 ==
        Enum.zip([line1, line2])
        |> Enum.count(fn
          {a, a} -> true
          _ -> false
        end)
    end)
  end
end
