defmodule CircularList do
  defstruct [:data, :pos, :len]

  def new(list) do
    %__MODULE__{
      data: build(list),
      pos: 0,
      len: length(list)
    }
  end

  def next(cl) do
    item = Map.get(cl.data, cl.pos)
    {item, increment(cl)}
  end

  def increment(%{pos: pos, len: len} = cl) do
    next_pos =
      case pos + 1 do
        pos when pos >= len -> 0
        pos -> pos
      end

    %{cl | pos: next_pos}
  end

  defp build(list) do
    list
    |> Enum.with_index()
    |> Enum.into(%{}, fn {value, index} -> {index, value} end)
  end
end
