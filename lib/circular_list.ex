defmodule CircularList do
  defstruct [:data, :pos, :len]
  def new(list) do
    %__MODULE__{
      data: :array.from_list(list),
      pos: 0,
      len: length(list)
    }
  end

  def next(cl) do
    case :array.get(cl.pos, cl.data) do
      :undefined -> {nil, cl}
      item -> {item, increment(cl)}
    end
  end

  def increment(%{pos: pos, len: len} = cl) do
    next_pos = case pos + 1 do
      pos when pos >= len -> 0
      pos -> pos
    end

    %{cl | pos: next_pos}
  end
end
