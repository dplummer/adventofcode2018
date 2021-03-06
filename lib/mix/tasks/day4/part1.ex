defmodule Mix.Tasks.Day4.Part1 do
  use Mix.Task

  @moduledoc """
  """

  def run(_args) do
    Application.ensure_started(:adventofcode2018)

    Result.run(fn ->
      File.read!("priv/day4_input.txt")
      |> strategy1()
    end)
  end

  def strategy1(raw) do
    {guard_id, records} =
      raw
      |> String.split("\n")
      |> Enum.map(&parse/1)
      |> Enum.sort_by(fn {dt, _} -> dt end, &dt_sorter/2)
      |> Enum.scan({nil, nil, nil}, &add_guard/2)
      |> Enum.group_by(fn {guard_id, _, _} -> guard_id end)
      |> Enum.max_by(fn {guard_id, records} ->
        {_, time_asleep} =
          records
          |> Enum.reduce({nil, 0}, fn
            {_, date2, :wakes_up} = line, {{_, date1, :falls_asleep}, acc} ->
              diff = NaiveDateTime.diff(date2, date1, :seconds) / 60
              {line, acc + diff}

            line, {_, acc} ->
              {line, acc}
          end)

        time_asleep
      end)

    records
    |> Enum.reduce({nil, []}, fn
      {_, date2, :wakes_up} = line, {{_, date1, :falls_asleep}, acc} ->
        {line, [{date1, date2} | acc]}

      line, {_, acc} ->
        {line, acc}
    end)
    |> elem(1)
    |> Enum.map(fn {date1, date2} ->
      {_, {_, min1, _}} = NaiveDateTime.to_erl(date1)
      {_, {_, min2, _}} = NaiveDateTime.to_erl(date2)
      min1..(min2 - 1)
    end)
    |> Enum.reduce(%{}, fn range, minutes ->
      range
      |> Enum.reduce(minutes, fn min, acc ->
        Map.update(acc, min, 1, &(&1 + 1))
      end)
    end)
    |> Enum.max_by(fn {minute, count} -> count end)
    |> elem(0)
    |> (&(&1 * guard_id)).()
  end

  def add_guard(line, {current_guard, _, _}) do
    case line do
      {date, "falls asleep"} ->
        {current_guard, date, :falls_asleep}

      {date, "wakes up"} ->
        {current_guard, date, :wakes_up}

      {date, begins_shift} ->
        [[_, guard_id]] = Regex.scan(~r/Guard #(\d+) begins shift/, begins_shift)
        guard_id = String.to_integer(guard_id)
        {guard_id, date, :begins_shift}
    end
  end

  def parse(line) do
    [[_, year, month, day, hour, minute, message]] =
      Regex.scan(~r/\[(\d+)-(\d+)-(\d+) (\d+):(\d+)\] (.+)/, line)

    {:ok, dt} =
      NaiveDateTime.new(
        String.to_integer(year),
        String.to_integer(month),
        String.to_integer(day),
        String.to_integer(hour),
        String.to_integer(minute),
        0
      )

    {
      dt,
      message
    }
  end

  def dt_sorter(a, b) do
    NaiveDateTime.compare(a, b) == :lt
  end
end
