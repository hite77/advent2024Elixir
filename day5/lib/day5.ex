defmodule Day5 do
  @moduledoc """
  Documentation for `Day5`.
  """

  @doc """
  Find the middle number

  ## Examples
      iex> Day5.middle([75,47,61,53,29])
      61
      iex> Day5.middle([97,61,53,29,13])
      53
      iex> Day5.middle([75,29,13])
      29
  """
  def middle(list) do
    Enum.at(list, div(length(list), 2))
  end
  @doc """
  Index of numbers and handle no match along with only calling it good if all the numbers are ordered or don't care.
  This is likely the integration test once it is parsed. Probably can manipulate data into this format.

  ## Examples
      iex> orders =   [[47,53],
      ...>            [97,13],
      ...>            [97,61],
      ...>            [97,47],
      ...>            [75,29],
      ...>            [61,13],
      ...>            [75,53],
      ...>            [29,13],
      ...>            [97,29],
      ...>            [53,29],
      ...>            [61,53],
      ...>            [97,53],
      ...>            [61,29],
      ...>            [47,13],
      ...>            [75,47],
      ...>            [97,75],
      ...>            [47,61],
      ...>            [75,61],
      ...>            [47,29],
      ...>            [75,13],
      ...>            [53,13]]
      iex> Day5.validUpdate(orders,[29,47])
      false
      iex> Day5.validUpdate(orders,[47,123])
      true
      iex> Day5.validUpdate(orders,[99])
      true
      iex> Day5.validUpdate(orders,[13,53])
      false
      iex> Day5.validUpdate(orders,[75,47,61,53,29])
      true
      iex> Day5.validUpdate(orders,[97,61,53,29,13])
      true
      iex> Day5.validUpdate(orders,[75,29,13])
      true
      iex> Day5.validUpdate(orders,[75,97,47,61,53])
      false
      iex> Day5.validUpdate(orders,[61,13,29])
      false
      iex> Day5.validUpdate(orders,[97,13,75,29,47])
      false
  """
  def validUpdate([], _update), do: true
  def validUpdate([head | tail], update) do
    [first,second] = head
    firstIndex = Enum.find_index(update, fn item -> item == first end)
    secondIndex = Enum.find_index(update, fn item -> item == second end)
    case [firstIndex, secondIndex] do
      [nil, _y] -> validUpdate(tail, update)
      [x  ,  y] when x < y -> validUpdate(tail, update)
      [x  ,  y] when x > y -> false
    end
  end
  @doc """

  ## Examples
      iex> orders =   [[47,53],
      ...>            [97,13],
      ...>            [97,61],
      ...>            [97,47],
      ...>            [75,29],
      ...>            [61,13],
      ...>            [75,53],
      ...>            [29,13],
      ...>            [97,29],
      ...>            [53,29],
      ...>            [61,53],
      ...>            [97,53],
      ...>            [61,29],
      ...>            [47,13],
      ...>            [75,47],
      ...>            [97,75],
      ...>            [47,61],
      ...>            [75,61],
      ...>            [47,29],
      ...>            [75,13],
      ...>            [53,13]]
      iex> Day5.sortInvalid([61,13,29], orders, orders)
      [61,29,13]
      iex> Day5.sortInvalid([75,97,47,61,53], orders, orders)
      [97,75,47,61,53]
      iex> Day5.sortInvalid([97,13,75,29,47], orders, orders)
      [97,75,47,29,13]
  """
  def sortInvalid(updates, [], _orders), do: updates
  def sortInvalid(updates, [head | tail], orders) do
    [first,second] = head
    firstIndex = Enum.find_index(updates, fn item -> item == first end)
    secondIndex = Enum.find_index(updates, fn item -> item == second end)
    case [firstIndex, secondIndex] do
      [nil, _y] -> sortInvalid(updates, tail, orders)
      [x  ,  y] when x < y -> sortInvalid(updates, tail, orders)
      [x  ,  y] when x > y -> sortInvalid(updates |> Enum.map(fn update -> swap(update,firstIndex,secondIndex, updates) end), orders, orders)
    end

  end
  # update
  #    p1 p2
  # 61 13 29
  def swap(update, pos1, pos2, updates) do
    case [update, Enum.at(updates, pos1), Enum.at(updates, pos2)] do
      [update, update, _] -> Enum.at(updates, pos2)
      [update, _, update] -> Enum.at(updates, pos1)
      [_, _, _]           -> update
    end
  end

  def convert([one, two]) do
    [String.to_integer(one), String.to_integer(two)]
  end

  def convertTuple(updates) do
    updates |> Enum.map(fn update -> String.to_integer(update) end)
  end

  def addUpValidMiddleNumbers(update, orders) do
    case validUpdate(orders, update) do
      true -> middle(update)
      false -> 0
    end
  end

  def addupCorrectedMiddleNumbers(update, orders) do
    case validUpdate(orders, update) do
      false -> update |> sortInvalid(orders, orders) |> middle()
      true -> 0
    end
  end

  def commonSetup(contents) do
    [raworders, rawupdates] = contents |> String.split("\n\n", trim: true)
    orders = raworders |> String.split("\n")
                       |> Enum.map(fn order -> order |> String.split("|") end)
                       |> Enum.map(fn order -> convert(order) end )
    updates = rawupdates |> String.split("\n")
                         |> Enum.map(fn update -> update |> String.split(",") end)
                         |> Enum.map(fn item -> convertTuple(item) end)
    [orders, updates]
  end

   @doc """
  Solve first the sample, then the days exercise.

      iex> {:ok, contents} = File.read("sample.txt")
      iex> Day5.part1(contents)
      143
  """
  def part1(contents) do
    [orders, updates] = contents |> commonSetup()
    updates |> Enum.reduce(0, fn update, acc -> acc + addUpValidMiddleNumbers(update, orders) end)
  end

  @doc """
  Part 2
  - Find the incorrect entries
  - correct the order on them
  - then add up the middle numbers.
      iex>{:ok, contents} = File.read("sample.txt")
      iex>Day5.part2(contents)
      123
  """
  def part2(contents) do
    [orders, updates] = contents |> commonSetup()
    updates |> Enum.reduce(0, fn update, acc -> acc + addupCorrectedMiddleNumbers(update, orders) end)
  end

  @doc """
  Solve 1

      iex> Day5.solve1()
      5509
  """
  def solve1() do
    {:ok, contents} = File.read("day5.txt")
    contents |> part1()
  end

   @doc """
  Solve 2

      iex> Day5.solve2()
      4407
  """
  def solve2() do
    {:ok, contents} = File.read("day5.txt")
    contents |> part2()
  end

end
