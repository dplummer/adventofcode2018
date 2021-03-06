defmodule Result do
  def run(func) do
    {time, result} = Benchmark.microseconds(func)

    IO.puts("Answer: #{inspect(result)}, took #{time / 1000}ms")
  end
end
