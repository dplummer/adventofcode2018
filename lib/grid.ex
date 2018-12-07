defmodule Grid do
  def new(), do: %{}

  def claim(full_grid, {x, y}, {width, height}, id) do
    Enum.reduce(x..(x + width - 1), full_grid, fn i, x_grid ->
      Enum.reduce(y..(y + height - 1), x_grid, fn j, y_grid ->
        add_claim(y_grid, i, j, id)
      end)
    end)
  end

  def add_claim(grid, x, y, id) do
    Map.update(grid, y, %{x => [id]}, fn row ->
      Map.update(row, x, [id], &[id | &1])
    end)
  end

  def print(grid) do
    IO.puts("")

    Map.keys(grid)
    |> Enum.sort()
    |> Enum.each(fn i ->
      case Map.get(grid, i) do
        nil ->
          nil

        row ->
          max = row |> Map.keys() |> Enum.max()

          0..max
          |> Enum.map(&Map.get(row, &1))
          |> Enum.map(fn
            nil -> "."
            [id] -> "#{id}"
            _ -> "X"
          end)
          |> Enum.join("")
          |> IO.puts()
      end
    end)

    grid
  end
end
