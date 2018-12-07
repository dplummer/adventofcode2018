defmodule Mix.Tasks.Day5.Part2 do
  use Mix.Task

  @moduledoc """
  """

  def run(_args) do
    Application.ensure_started(:adventofcode2018)

    Result.run(fn ->
      File.stream!("priv/day5_input.txt", [], 1)
      |> part2()
    end)
  end

  def part2(stream) do
    {_, count} =
      hd('a')..hd('z')
      |> Enum.map(fn char_point ->
        lower_str = "#{[char_point]}"
        upper_str = "#{[char_point - 32]}"

        count =
          stream
          |> Enum.reduce([], fn
            "\n", acc ->
              acc

            ^lower_str, acc ->
              acc

            ^upper_str, acc ->
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

        {char_point, count}
      end)
      |> Enum.min_by(fn {_, count} -> count end)

    count
  end

  def cancel?(a, b) do
    case hd(String.to_charlist(a)) - hd(String.to_charlist(b)) do
      -32 -> true
      32 -> true
      _ -> false
    end
  end
end
