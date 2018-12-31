defmodule Mix.Tasks.Day6.Part2 do
  use Mix.Task

  @moduledoc """
  """

  def run(_args) do
    Application.ensure_started(:adventofcode2018)

    Result.run(fn ->
      # File.stream!("priv/day6_input.txt")
      """
      1, 1
      1, 6
      8, 3
      3, 4
      5, 5
      8, 9
      """
      |> String.split("\n")
      |> Enum.filter(& &1 != "")
      |> part2()
    end)
  end

  def part2(stream) do
    coords =
      stream
      |> Stream.map(&parse/1)
      |> Enum.to_list()

    min_x = coords |> Enum.map(&elem(&1, 0)) |> Enum.min()
    max_x = coords |> Enum.map(&elem(&1, 0)) |> Enum.max()
    min_y = coords |> Enum.map(&elem(&1, 1)) |> Enum.min()
    max_y = coords |> Enum.map(&elem(&1, 1)) |> Enum.max()

    for(x <- min_x..max_x, y <- min_y..max_y, do: {x, y})
    |> Enum.map(&calculate_distances(coords, &1))
    |> Enum.reduce(%{}, fn
      {_, [coord]}, acc -> Map.update(acc, coord, 1, & &1 + 1)
        {_, _}, acc -> acc
    end)
    |> Enum.max_by(&elem(&1, 1))
  end

  def parse(line) do
    line
    |> String.trim()
    |> String.split(", ")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def calculate_distances(input_coords, {x, y} = _map_coord) do
    input_coords
    |> Enum.reduce(0, fn {coord_x, coord_y} = coord, {record_distance, record_coords} = acc ->
      distance = abs(coord_x - x) + abs(coord_y - y)
      cond do
        distance < record_distance -> {distance, [coord]}
        distance == record_distance -> {distance, [coord | record_coords]}
        true -> acc
      end
    end)
  end
end
