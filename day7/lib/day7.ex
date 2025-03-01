defmodule Day7 do
  @moduledoc """
  Documentation for `Day7`.
  """

  @doc """
  Parse extracts the values.

      iex> Day7.parse("190: 10 19")
      [190, [10, 19]]
  """
  def parse(item) do
    [product, pieces] = item
                          |> String.split(":",trim: true)
    parsed = pieces
              |> String.trim()
              |> String.split(" ")
              |> Enum.map(fn piece -> String.to_integer(piece) end)
    [String.to_integer(product), parsed]
  end

  # 292: 11x6x16x20 is length -1 digits binary
  @doc """
  Create a fixed length binary string.

      iex>Day7.binaryToLength(31,5,2)
      "11111"
      iex>Day7.binaryToLength(30,5,2)
      "11110"
      iex>Day7.binaryToLength(14,5,2)
      "01110"
      iex>Day7.binaryToLength(3,5,2)
      "00011"

  """
  def binaryToLengthPart(counter, length, part) when part == :part1, do: binaryToLength(counter, length, 2)
  def binaryToLengthPart(counter, length, part) when part == :part2, do: binaryToLength(counter, length, 3)
  def binaryToLength(counter, length, base) do
    binary = Integer.to_string(counter,base)
    case length-String.length(binary) do
      0 -> binary
      x -> String.duplicate("0",x) <> binary
    end
  end

  @doc """
  Calculate the sum and products

      iex>Day7.calculate([10,5,34], ["1","0"], 0, 84)
      84
  """
  def caclulate([_], [_], sum, product) when sum > product, do: 0
  def calculate([_], [], sum, _), do: sum
  def calculate([first, second | tailNumbers], [operator | tail], sum, product) do
    case [operator, sum] do
      ["2", 0] -> calculate([second | tailNumbers], tail, String.to_integer(Integer.to_string(first) <> Integer.to_string(second)), product)
      ["1", 0] -> calculate([second | tailNumbers], tail, sum + first * second, product)
      ["0", 0] -> calculate([second | tailNumbers], tail, sum + first + second, product)
      ["2", _] -> calculate([second | tailNumbers], tail, String.to_integer(Integer.to_string(sum) <> Integer.to_string(second)), product)
      ["1", _] -> calculate([second | tailNumbers], tail, sum * second, product)
      ["0", _] -> calculate([second | tailNumbers], tail, sum + second, product)
    end
  end

  @doc """
  Recurse combinations of * and +
      iex> Day7.combinations([292,[11, 6, 16, 20]],:part1)
      292
      iex> Day7.combinations([42,[2,1,39]],:part1)
      42
      iex> Day7.combinations([161011, [16, 10, 13]],:part1)
      0
  """
  def combinations([_, _], counter, _, _) when counter == -1, do: 0
  def combinations([product, list], counter, length, part) do
    # String.graphemes
    case calculate(list, binaryToLengthPart(counter, length, part) |> String.graphemes(), 0, product) == product do
    true -> product
    false -> combinations([product, list], counter-1, length, part)
    end
  end
  def combinations([product, list], part) do
    # might have to count the number of digits needed * or + (*1,+0)
    # have a counter that it calls this function with those values and then build out a list of operators
    # [Integer.to_string(3, 2), Integer.to_string(243, 2)] ["11", "11110011"]
    numberOfOperators = length(list)-1
    case part do
      :part1 -> combinations([product, list], (2**numberOfOperators)-1, numberOfOperators, part)
      :part2 -> combinations([product, list], (3**numberOfOperators)-1, numberOfOperators, part)
    end

  end

  #  3 bits 8
  #  000 1
  #  001 2
  #  010 3
  #  011 4
  #  100 5
  #  101 6
  #  110 7
  #  111 7
  @doc """
  Part 1 is the sum of the left numbers that be made by placing + and * treat as binary.
  336348203 is too low
  7579994664753

  12 || 345 would become 12345 3rd operator.... base 3
  counter will be higher
  conversion
  need to support the concatentation -> both to strings and <> and then back at integer


  ## Examples
      iex> {:ok, content} = File.read("sample.txt")
      iex> Day7.parts(content)
      [:part1, 3749, :part2, 11387]

      iex> {:ok, content} = File.read("day7.txt")
      iex> Day7.parts(content)
      [:part1, 7579994664753, :part2, 438027111276610]
  """
  def parts(content) do
    parsed = content
              |> String.split("\n")
              |> Enum.map(fn entry -> parse(entry) end)
    part1 = parsed
              |> Enum.map(fn row -> combinations(row, :part1) end)
              |> Enum.sum()
    part2 = parsed
              |> Enum.map(fn row -> combinations(row, :part2) end)
              |> Enum.sum()
    [:part1, part1, :part2, part2]
  end
end
