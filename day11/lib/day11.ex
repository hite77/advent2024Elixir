defmodule Day11 do
  @moduledoc """
  Documentation for `Day11`.
  """
require Integer

  @doc """
  As you observe them for a while, you find that the stones have a consistent behavior.
  Every time you blink, the stones each simultaneously change according to the first applicable rule in this list:

    Encoded.
    If the stone is engraved with the number 0, it is replaced by a stone engraved with the number 1.


    If the stone is engraved with a number that has an even number of digits, it is replaced by two stones.
    The left half of the digits are engraved on the new left stone, and the right half of the digits are engraved on the
    new right stone. (The new numbers don't keep extra leading zeroes: 1000 would become stones 10 and 0.)

    If none of the other rules apply, the stone is replaced by a new stone; the old stone's number multiplied by 2024
    is engraved on the new stone.

    No matter how the stones change, their order is preserved, and they stay on their perfectly straight line.

    How will the stones evolve if you keep blinking at them? You take a note of the number engraved on each stone in the line (your puzzle input).

    If you have an arrangement of five stones engraved with the numbers 0 1 10 99 999 and you blink once, the stones transform as follows:

    The first stone, 0, becomes a stone marked 1.
    The second stone, 1, is multiplied by 2024 to become 2024.
    The third stone, 10, is split into a stone marked 1 followed by a stone marked 0.
    The fourth stone, 99, is split into two stones marked 9.
    The fifth stone, 999, is replaced by a stone marked 2021976.
    So, after blinking once, your five stones would become an arrangement of seven stones engraved with the numbers
    1 2024 1 0 9 9 2021976.

      iex>Day11.parse("0 1 10 99 999")
      %{{0, 0} => 1, {1, 0} => 1, {10, 0} => 1, {99, 0} => 1, {999, 0} => 1}

      iex>{:ok, day11Content} = File.read("day11.txt")
      iex>Day11.parse(day11Content)
      %{
              {0, 0} => 1,
              {4, 0} => 1,
              {28, 0} => 1,
              {490, 0} => 1,
              {3179, 0} => 1,
              {96938, 0} => 1,
              {816207, 0} => 1,
              {6617406, 0} => 1
            }
      iex>Day11.parts(day11Content, 25)
      189167  #Part 1 answer
      iex>Day11.parts(day11Content, 75)
      225253278506288

      #16979582 is too low...


  """
  def parse(content) do
    content
      |> String.split(" ")
      |> Enum.map(fn item -> String.to_integer(item) end)
      |> Enum.map(fn item -> {item, 0} end)
      |> turnToMap(%{})
  end

  def turnToMap([], map), do: map
  def turnToMap([head | tail], map) do
    turnToMap(tail, Map.put(map, head, 1))
  end

  def addValues([], map, _, _), do: map
  def addValues([head | tail], map, level, count) do
    case Map.get(map, {head, level}) do
      nil -> addValues(tail, Map.put(map, {head, level}, count), level, count)
      _   -> addValues(tail, Map.put(map, {head, level}, Map.get(map, {head, level}) + count), level, count)
    end
  end
  def addToMap([], map, current, blinks) when current == blinks, do: map
  def addToMap([], map, current, blinks), do: addToMap(getKeysForRow(map, current), map, current + 1, blinks)
  def addToMap([head | tail], map, current,blinks) do
    {stone, _level} = head
    countAtLevel = Map.get(map, head) # sum this
    case Map.get(map, {stone, current-1}) do
      nil ->  map = addValues(calculateNextStone(stone), map, current, 1) #1 or two stones will be 1 *
              addToMap(tail, map, current, blinks)
      # And CountAtLevel to each of the stones.
      _   ->  map = addValues(calculateNextStone(stone), map, current, countAtLevel)
              addToMap(tail, map, current, blinks)
    end
  end


@doc """
    Function to get a list of keys which will be the level to work on next
    We will call addToMap Feeding this entire map in, and head | tail of keys to work.
        iex>Day11.getKeysForRow(%{{0, 0} => 1, {1, 0} => 1, {10, 1} => 1, {99, 1} => 1, {999, 0} => 1}, 1)
        [{99, 1}, {10, 1}]
"""
  def filterKeys([], _, list), do: list
  def filterKeys([head | tail], level, list) do
    {_, l} = head
    case l == level do
      true -> filterKeys(tail, level, [head | list])
      false -> filterKeys(tail, level, list)
    end
  end
  def getKeysForRow(map, level) do
    filterKeys(Map.keys(map), level, [])
  end
  @doc """
        iex>Day11.calculateNextStone(0)
        [1]
        iex>Day11.calculateNextStone(1)
        [2024]
        iex>Day11.calculateNextStone(20)
        [2,0]
  """
  def calculateNextStone(stone) do
    digits = Integer.digits(stone)
    countSplit = Enum.count(digits)
    case [stone == 0,Integer.is_even(countSplit)] do
      [true, _] -> [1]
      [_, true] -> split(stone)
      [_, false] -> [stone * 2024]
    end
  end


  def split(stone) do
  num_digits = floor(:math.log10(stone)) + 1

    if Integer.mod(num_digits, 2) == 0 do
      divisor = 10 ** div(num_digits, 2)
      left = div(stone, divisor)
      right = rem(stone, divisor)
      [left, right]
    end
  end

  def parts(content, count) do
    map = content |> parse()
    fullMap = addToMap(getKeysForRow(map, 0), map, 1, count)
    fullMap |> sumUp(getKeysForRow(fullMap, count), 0)
  end

  def sumUp(_, [], sum), do: sum
  def sumUp(map, [head | tail], sum) do
    sumUp(map, tail, sum + Map.get(map, head))
  end
end
