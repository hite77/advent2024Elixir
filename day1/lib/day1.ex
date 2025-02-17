defmodule Day1 do
  @moduledoc """
  Documentation for `Day1`.
  """

  def convert(line) do
    [first, second | _] = String.replace(line, ~r/\s+/, " ") |> String.split(" ")
    {first, _} = Integer.parse(first)
    {second, _} = Integer.parse(second)
    [[first], [second]]
  end

  @doc """
  Parse.

  ## Examples

      iex> Day1.parse("35430   67143", [])
      [[35430], [67143]]

      iex> Day1.parse("56      73", [[35430], [67143]])
      [[56,35430], [73,67143]]
  """
  def parse(line, []),  do: convert(line)
  def parse(line, [[head1 | tail1], [head2 | tail2]]) do
    [[newFirst], [newSecond]] = line |> convert()
    [[newFirst, head1 | tail1], [newSecond, head2 | tail2]]
  end

  @doc """
  Difference

  ## Examples

      iex> Day1.difference([[3],[5]])
      2
      iex> Day1.difference([Enum.sort([3,4,2,1,3,3]), Enum.sort([4,3,5,3,9,3])])
      11
  """

  def difference([[last1], [last2]]), do: abs(last1 - last2)
  def difference([[head1 | tail1], [head2 | tail2]]) do
    abs(head1 - head2) + difference([tail1, tail2])
  end

  @doc """
  Solve for addition of all

  ## Examples
      iex> Day1.solve1()
      2264607
  """

  def solve1 do
    {:ok, contents} = File.read("day1.txt")
    [list1, list2] = contents |> String.split("\n", trim: true)
                              |> Enum.reduce([], fn (item, output) -> parse(item, output) end)
    [Enum.sort(list1), Enum.sort(list2)] |> difference()
  end
end
