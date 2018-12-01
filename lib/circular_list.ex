defmodule CircularList do
  defstruct [:data, :pos, :len]
  def new(list) do
    %__MODULE__{
      data: list,
      pos: 0,
      len: length(list)
    }
  end

  def next(cl) do
    item = Enum.at(cl.data, cl.pos)
    {item, increment(cl)}
  end

  def increment(%{pos: pos, len: len} = cl) do
    next_pos = case pos + 1 do
      pos when pos >= len -> 0
      pos -> pos
    end

    %{cl | pos: next_pos}
  end
end
