defmodule Mix.Tasks.Day5.Part1 do
  use Mix.Task

  @moduledoc """
  """

  def run(_args) do
    Application.ensure_started(:adventofcode2018)

    Result.run(fn ->
      File.stream!("priv/day5_input.txt", [], 1)
      # "dabAcCaCBAcCcaDA" |> String.graphemes
      |> part1()
    end)
  end

  def part1(stream) do
    stream
    |> Enum.reduce([], fn
      "\n", acc ->
        acc

      char, [] ->
        [char]

      char, [last_char | previous_chars] = acc ->
        if cancel?(char, last_char) do
          previous_chars
        else
          [char | acc]
        end
    end)
    |> Enum.count()
  end

  def cancel?(a, b) do
    case hd(String.to_charlist(a)) - hd(String.to_charlist(b)) do
      -32 -> true
      32 -> true
      _ -> false
    end
  end
end
