defmodule Mix.Tasks.Day3.Part1 do
  use Mix.Task

  @moduledoc """
  --- Day 3: No Matter How You Slice It ---
  The Elves managed to locate the chimney-squeeze prototype fabric for Santa's suit (thanks to
  someone who helpfully wrote its box IDs on the wall of the warehouse in the middle of the
  night).  Unfortunately, anomalies are still affecting them - nobody can even agree on how to cut
  the fabric.

  The whole piece of fabric they're working on is a very large square - at least 1000 inches on
  each side.

  Each Elf has made a claim about which area of fabric would be ideal for Santa's suit. All claims
  have an ID and consist of a single rectangle with edges parallel to the edges of the fabric.
  Each claim's rectangle is defined as follows:

  The number of inches between the left edge of the fabric and the left edge of the rectangle.
  The number of inches between the top edge of the fabric and the top edge of the rectangle.
  The width of the rectangle in inches.
  The height of the rectangle in inches.
  A claim like #123 @ 3,2: 5x4 means that claim ID 123 specifies a rectangle 3 inches from the
  left edge, 2 inches from the top edge, 5 inches wide, and 4 inches tall. Visually, it claims the
  square inches of fabric represented by # (and ignores the square inches of fabric represented by
  .) in the diagram below:

  ...........
  ...........
  ...#####...
  ...#####...
  ...#####...
  ...#####...
  ...........
  ...........
  ...........
  The problem is that many of the claims overlap, causing two or more claims to cover part of the
  same areas. For example, consider the following claims:

  #1 @ 1,3: 4x4
  #2 @ 3,1: 4x4
  #3 @ 5,5: 2x2
  Visually, these claim the following areas:

  ........
  ...2222.
  ...2222.
  .11XX22.
  .11XX22.
  .111133.
  .111133.
  ........
  The four square inches marked with X are claimed by both 1 and 2. (Claim 3, while adjacent to
  the others, does not overlap either of them.)

  If the Elves all proceed with their own plans, none of them will have enough fabric. How many
  square inches of fabric are within two or more claims?
  """

  def run(_args) do
    Application.ensure_started(:adventofcode2018)

    Result.run(fn ->
      File.read!("priv/day3_input.txt")
      |> count_overlapping_claims()
    end)
  end

  def count_overlapping_claims(raw) do
    raw
    |> String.split("\n")
    |> Enum.reduce(Grid.new(), &overlay_claims/2)
    |> count_duplicates()
  end

  def overlay_claims(line, grid) do
    {id, x, y, width, height} = parse_line(line)
    Grid.claim(grid, {x, y}, {width, height}, id)
  end

  def parse_line(line) do
    result =
      Regex.named_captures(
        ~r/\A#(?<id>\d+) @ (?<x>\d+),(?<y>\d+): (?<width>\d+)x(?<height>\d+)\z/,
        line
      )

    [result["id"], result["x"], result["y"], result["width"], result["height"]]
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def count_duplicates(claims) do
    claims
    |> Enum.reduce(0, fn {_, row}, acc ->
      Enum.reduce(row, acc, fn
        {_, cell}, acc when length(cell) > 1 -> acc + 1
        _, acc -> acc
      end)
    end)
  end
end
