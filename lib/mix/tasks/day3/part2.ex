defmodule Mix.Tasks.Day3.Part2 do
  use Mix.Task

  @moduledoc """
  --- Part Two ---
  Amidst the chaos, you notice that exactly one claim doesn't overlap by even a single square inch
  of fabric with any other claim. If you can somehow draw attention to it, maybe the Elves will be
  able to make Santa's suit after all!

  For example, in the claims above, only claim 3 is intact after all claims are made.

  What is the ID of the only claim that doesn't overlap?
  """

  def run(_args) do
    Application.ensure_started(:adventofcode2018)

    Result.run(fn ->
      File.read!("priv/day3_input.txt")
      |> find_non_overlapping_claim()
    end)
  end

  def find_non_overlapping_claim(raw) do
    raw
    |> String.split("\n")
    |> Enum.reduce(Grid.new(), &overlay_claims/2)
    |> find_non_overlapping()
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

  def find_non_overlapping(claims) do
    claims
    |> Enum.reduce({MapSet.new(), MapSet.new()}, fn {_, row}, acc ->
      Enum.reduce(row, acc, fn
        {_, [id]}, {candidates, rejection} ->
          case id in rejection do
            true -> {candidates, rejection}
            false -> {MapSet.put(candidates, id), rejection}
          end

        {_, ids}, acc ->
          Enum.reduce(ids, acc, fn id, {candidates, rejection} ->
            {MapSet.delete(candidates, id), MapSet.put(rejection, id)}
          end)
      end)
    end)
    |> elem(0)
    |> MapSet.to_list()
    |> hd
  end
end
