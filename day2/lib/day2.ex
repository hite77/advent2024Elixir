defmodule Day2 do
  @moduledoc """
  Documentation for `Day2`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Day2.hello()
      :world

  """
  def hello do
    :world
  end

  @doc """
  Parse

  ## Examples
      iex> Day2.parse("65 67 70 72 74 73")
      [65,67,70,72,74,73]
  """

  # This is where I'm leaving off, need to reduce, or map...
  # likely map.
  def parse(line) do
    line |> String.split(" ")
         |> Enum.map(fn item -> {value, _} = Integer.parse(item); value end)
  end

  @doc """
  Difference is at least 1, 2, or 3
  Must be either increasing or decreasing

  ## Examples

      iex> Day2.safe([7,6,4,2,1])
      1

      iex> Day2.safe([1,2,7,8,9])
      0

      iex> Day2.safe([9,7,6,2,1])
      0

      iex> Day2.safe([1,3,2,4,5])
      0

      iex> Day2.safe([8,6,4,4,1])
      0

      iex> Day2.safe([1,3,6,7,9])
      1
  """

  def increasing([_last]), do: 1
  def increasing([head, second | tail]) do
    case  (second - head) do
      1 -> increasing([second | tail])
      2 -> increasing([second | tail])
      3 -> increasing([second | tail])
      _ -> 0
    end
  end

  def decreasing([_last]), do: 1
  def decreasing([head, second | tail]) do
    case (head - second) do
    1 -> decreasing([second | tail])
    2 -> decreasing([second | tail])
    3 -> decreasing([second | tail])
    _ -> 0
    end
  end

  def safe([head, second | tail]) do
    cond do
      second - head > 0 -> increasing([head, second | tail])
      true -> decreasing([head, second | tail])
    end
  end

  @doc """
  Solve 1

      iex> Day2.solve1()
      218
  """

  def solve1() do
    {:ok, contents} = File.read("day2.txt")
    contents |> String.split("\n", trim: true)
             |> Enum.map(fn line -> parse(line) end)
             |> Enum.map(fn line -> safe(line) end)
             |> Enum.sum()
  end

#  Idea: create spread function
    # Will take list and create this spread([1,2,3])
    # [[2,3],[1,3],[1,2]] maybe different order
    # Then map that it calls safe on each of these (0, or 1)
    # Then return that Enum.sum of then condition....
    # if 0 return 0, all others 1.
    # may be a more brute force, but see how fast it is.


  @doc """
  Spread With One Out
  Leaves out each digit in turn, and returns all the options.

      iex> Day2.spreadWithOneOut([1,2,3])
      [[2,3],[1,3],[1,2]]

      iex> Day2.spreadWithOneOut([1,2,3,4])
      [[2,3,4],[1,3,4],[1,2,4],[1,2,3]]
  """
#  iex> Day2.spreadWithOneOut([2,3],1, [[2,3]])
#  :Ignore

  # TODO might need to make this single item.
  def spreadWithOneOut([_], list, [head2 | tail2]) do
    Enum.concat([head2 | tail2], [list])
  end
  def spreadWithOneOut([head | tail], start, [output]) do
    spreadWithOneOut(tail, [start , head], [output , [start | tail]])
  end
  def spreadWithOneOut([head1 | tail1], [head2 | tail2], output) do
    spreadWithOneOut(tail1, Enum.concat([head2 | tail2], [head1]), Enum.concat(output, [Enum.concat([head2 | tail2], tail1)]))
  end
  def spreadWithOneOut([head | tail]) do
    spreadWithOneOut(tail, head, [tail])
  end


  def compareToZero(entry) do
    case entry == 0 do
      true -> 0
      false -> 1
    end
  end

  @doc """
  Solve 2

    iex> Day2.solve2()
    290

  """


  def solve2() do
    {:ok, contents} = File.read("day2.txt")
    contents |> String.split("\n", trim: true)
             |> Enum.map(fn line -> parse(line) end)
             |> Enum.map(fn line -> spreadWithOneOut(line) end)
             |> Enum.map(fn line -> Enum.map(line, fn option -> safe(option) end) end)
             |> Enum.map(fn line -> Enum.sum(line) end)
             |> Enum.map(fn entry -> compareToZero(entry) end)
             |> Enum.sum()
  end
end
