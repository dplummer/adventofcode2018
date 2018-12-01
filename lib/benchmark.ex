defmodule Benchmark do
  def microseconds(func) do
    now = :os.system_time(:microsecond)
    result = func.()
    {:os.system_time(:microsecond) - now, result}
  end
end
