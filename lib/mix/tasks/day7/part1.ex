defmodule Mix.Tasks.Day7.Part1 do
  use Mix.Task

  defmodule Step do
    defstruct [:name, :children]
    def new(name, child), do: %__MODULE__{name: name, children: [child]}
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
      # |> Enum.filter(& &1 != "")
      |> part1()
    end)
  end

  def part1(stream) do
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
