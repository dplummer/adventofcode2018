defmodule Mix.Tasks.Day7.Part1 do
  use Mix.Task

  defmodule Step do
    defstruct [name: nil, children: [], prereq: []]
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
      |> part1()
    end)
  end

  def part1(stream) do
    stream
    |> Enum.map(&parse/1)
    |> Enum.reduce([], fn {name, child}, acc ->
      acc
      |> Keyword.update(name, %Step{name: name, children: [child]}, fn existing_step ->
        %{existing_step | children: Enum.sort([child | existing_step.children])}
      end)
      |> Keyword.update(child, %Step{name: child, prereq: [name]}, fn existing_step ->
        %{existing_step | prereq: [name | existing_step.prereq]}
      end)
    end)
    |> Enum.map(fn {_, step} -> step end)
    |> Enum.sort_by(& &1.name)
    |> step_sort([], [])
    |> print()
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

  def part1x(stream) do
    stream
    |> Enum.map(&parse/1)
    |> Enum.map(fn {name, child} -> Step.new(name, child) end)
    |> Enum.reduce([], fn step, acc ->
      Keyword.update(acc, step.name, step, fn existing_step ->
        %{existing_step | children: Enum.sort(step.children ++ existing_step.children)}
      end)
    end)
    |> build_order([])
    |> print()
  end

  def build_order([{_, %{name: name, children: children}} | steps], []) do
    build_order(steps, [name] ++ children)
  end
  def build_order([{_, %{name: name, children: children}} | steps], acc) do
    new_acc = case Enum.split_while(acc, fn x -> x != name end) do
      {fore, [^name | aft]} ->
        fore = Enum.filter(fore, & &1 not in children)
        fore ++ [name] ++ Enum.uniq(Enum.sort(children ++ aft))
      {fore, []} ->
        fore = Enum.filter(fore, & &1 not in children)
        fore ++ [name | children]
    end
    if new_acc != Enum.uniq(new_acc) do
      IO.inspect(print(acc), label: "was")
      IO.inspect({name, children})
      print(acc) |> IO.inspect
    end
    build_order(steps, new_acc)
  end
  def build_order([], acc), do: acc

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
