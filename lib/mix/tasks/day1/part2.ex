defmodule Mix.Tasks.Day1.Part2 do
  use Mix.Task

  @moduledoc """
  --- Part Two ---
  You notice that the device repeats the same frequency change list over and over. To calibrate the
  device, you need to find the first frequency it reaches twice.

  For example, using the same list of changes above, the device would loop as follows:

  Current frequency  0, change of +1; resulting frequency  1.
  Current frequency  1, change of -2; resulting frequency -1.
  Current frequency -1, change of +3; resulting frequency  2.
  Current frequency  2, change of +1; resulting frequency  3.
  (At this point, the device continues from the start of the list.)
  Current frequency  3, change of +1; resulting frequency  4.
  Current frequency  4, change of -2; resulting frequency  2, which has already been seen.
  In this example, the first frequency reached twice is 2. Note that your device might need to
  repeat its list of frequency changes many times before a duplicate frequency is found, and that
  duplicates might be found while in the middle of processing the list.

  Here are other examples:

  +1, -1 first reaches 0 twice.
  +3, +3, +4, -2, -4 first reaches 10 twice.
  -6, +3, +8, +5, -6 first reaches 5 twice.
  +7, +7, -2, -7, -4 first reaches 14 twice.
  What is the first frequency your device reaches twice?
  """

  @shortdoc "Day1 part1"
  def run(_args) do
    Application.ensure_started(:adventofcode2018)

    Result.run(fn ->
      data =
        File.read!("priv/day1_input.txt")
        |> String.split("\n")
        |> Enum.map(fn
          "+" <> value -> String.to_integer(value)
          value -> String.to_integer(value)
        end)
        |> CircularList.new()

      find_duplicate(data, MapSet.new(), 0, 0)
    end)
  end

  def find_duplicate(data, seen, current_freq, iterations) do
    {value, data} = CircularList.next(data)
    new_freq = current_freq + value

    if MapSet.member?(seen, new_freq) do
      {new_freq, iterations}
    else
      find_duplicate(data, MapSet.put(seen, new_freq), new_freq, iterations + 1)
    end
  end
end
