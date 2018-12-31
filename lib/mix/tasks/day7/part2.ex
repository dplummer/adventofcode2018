defmodule Mix.Tasks.Day7.Part2 do
  use Mix.Task

  defmodule Step do
    defstruct [name: nil, children: [], prereq: [], time: 0]
    def new(name, opts) do
      work_time = name
                  |> Atom.to_string
                  |> String.to_charlist
                  |> hd
      time = 60 + work_time - 64
      %Step{name: name, time: time}
      |> struct(opts)
    end
  end

  defmodule Worker do
    defstruct [step: nil, started: nil]
    use GenServer
    def start_link(_) do
      {:ok, pid} = GenServer.start_link(__MODULE__, %__MODULE__{})
      pid
    end

    def assign_work(workers, step, t) do
      workers
      |> Enum.find(fn pid ->
        GenServer.call(pid, {:work, step, t})
      end)
    end

    def time_passed(workers, t) do
      workers |> Enum.reduce([], fn pid, acc ->
        case GenServer.call(pid, {:time, t}) do
          nil -> acc
          step -> [step | acc]
        end
      end)
    end

    def all_done?(workers) do
      workers |> Enum.all?(&GenServer.call(&1, :done?))
    end

    def inspect(workers) do
      workers |> Enum.map(&GenServer.call(&1, :get_name)) |> Enum.join("")
    end

    def handle_call(:get_name, _from, %{step: nil} = state), do: {:reply, "", state}
    def handle_call(:get_name, _from, %{step: %{name: name}} = state), do: {:reply, Atom.to_string(name), state}

    def handle_call(:done?, _from, %{step: nil} = state), do: {:reply, true, state}
    def handle_call(:done?, _from, %{step: %Step{}} = state), do: {:reply, false, state}

    def handle_call({:work, step, t}, _from, %{step: nil} = state) do
      {:reply, true, %{state | step: step, started: t}}
    end
    def handle_call({:work, _step, _t}, _from, state) do
      {:reply, false, state}
    end

    def handle_call({:time, t}, _from, %{step: nil} = state), do: {:reply, nil, state}
    def handle_call({:time, t}, _from, state) do
      if t >= state.step.time + state.started do
        {:reply, state.step, %{state | step: nil, started: nil}}
      else
        {:reply, nil, state}
      end
    end
  end

  @moduledoc """
  """

  def run(_args) do
    Application.ensure_started(:adventofcode2018)

    Result.run(fn ->
      File.stream!("priv/day7_input.txt")
      # """
      # Step C must be finished before step A can begin.
      # Step C must be finished before step F can begin.
      # Step A must be finished before step B can begin.
      # Step A must be finished before step D can begin.
      # Step B must be finished before step E can begin.
      # Step D must be finished before step E can begin.
      # Step F must be finished before step E can begin.
      # """
      # |> String.split("\n")
      |> Enum.filter(& &1 != "")
      |> part2(5)
    end)
  end

  def part2(stream, num_workers) do
    stream
    |> Enum.map(&parse/1)
    |> Enum.reduce([], fn {name, child}, acc ->
      acc
      |> Keyword.update(name, Step.new(name, children: [child]), fn existing_step ->
        %{existing_step | children: Enum.sort([child | existing_step.children])}
      end)
      |> Keyword.update(child, Step.new(child, prereq: [name]), fn existing_step ->
        %{existing_step | prereq: [name | existing_step.prereq]}
      end)
    end)
    |> Enum.map(fn {_, step} -> step end)
    |> Enum.sort_by(& &1.name)
    |> step_sort([], [])
    |> do_work(Enum.map(1..num_workers, &Worker.start_link/1), [], 0)
  end

  def step_sort([], [], acc), do: Enum.reverse(acc)
  def step_sort([%Step{prereq: []} = step | steps], hold, acc), do: step_sort(hold ++ steps, [], [step | acc])
  def step_sort([step | steps], hold, acc) do
    step_names = Enum.map(acc, & &1.name)
    if Enum.all?(step.prereq, fn req_name -> req_name in step_names end) do
      step_sort(hold ++ steps, [], [step | acc])
    else
      step_sort(steps, hold ++ [step], acc)
    end
  end

  def do_work([], workers, completed, t) do
    completed = Worker.time_passed(workers, t) ++ completed

    if Worker.all_done?(workers) do
      t
    else
      do_work([], workers, completed, t + 1)
    end
  end
  def do_work(steps, workers, completed, t) do
    completed = Worker.time_passed(workers, t) ++ completed

    {_assigned_steps, unassigned_steps} = steps
    |> Enum.split_with(fn
      %Step{prereq: []} = step ->
        Worker.assign_work(workers, step, t)

      %Step{prereq: prereq} = step ->
        step_names = Enum.map(completed, & &1.name)
        if Enum.all?(prereq, fn req_name -> req_name in step_names end) do
          Worker.assign_work(workers, step, t)
          |> IO.inspect(label: "assigning work #{step.name}")
        else
          false
        end
    end)

    IO.puts("[#{t}] Workers: #{Worker.inspect(workers)} ; Completed: #{completed |> Enum.map(& &1.name) |> Enum.join("")}")
    do_work(unassigned_steps, workers, completed, t + 1)
  end

  def print(acc) do
    acc
    |> Enum.map(& &1.name)
    |> Enum.map(&Atom.to_string/1)
    |> Enum.join("")
  end

  def parse(line) do
    [_, a, _, _, _, _, _, b, _, _] =
    line
    |> String.trim()
    |> String.split(" ")
    {String.to_atom(a), String.to_atom(b)}
  end

end
