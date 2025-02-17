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

  def commonsetup do
    {:ok, contents} = File.read("day1.txt")
    contents |> String.split("\n", trim: true)
                              |> Enum.reduce([], fn (item, output) -> parse(item, output) end)
  end

  @doc """
  Solve for addition of all

  ## Examples
      iex> Day1.solve1()
      2264607
  """

  def solve1 do
    [list1, list2] = commonsetup()
    [Enum.sort(list1), Enum.sort(list2)] |> difference()
  end

  @doc """
  Count

  ## Examples
      iex> Day1.count(3, [4,3,5,3,9,3])
      3

      iex> Day1.count(4, [4,3,5,3,9,3])
      1

      iex> Day1.count(42, [4,3,5,3,9,3])
      0
  """

  def count(find, list), do: Enum.count(list, &(&1 == find))

  @doc """
  Similarity the number multiplied by how many times

  ## Examples
      iex> Day1.similarity([[3,4,2,1,3,3], [4,3,5,3,9,3]])
      31
  """

  def similarity([[lastitem], list]), do: lastitem * count(lastitem, list)
  def similarity([[head | tail], list]), do:  head * count(head, list) + similarity([tail, list])

  @doc """
  Solve for simularity of all

  ## Examples
      iex> Day1.solve2()
      :answer
  """

def solve2 do
  commonsetup() |> similarity()
end

end
