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

      iex>Day7.binaryToLength(31,5)
      "11111"
      iex>Day7.binaryToLength(30,5)
      "11110"
      iex>Day7.binaryToLength(14,5)
      "01110"
      iex>Day7.binaryToLength(3,5)
      "00011"

  """
  def binaryToLength(counter, length) do
    binary = Integer.to_string(counter,2)
    case length-String.length(binary) do
      0 -> binary
      x -> String.duplicate("0",x) <> binary
    end
  end

  @doc """
  Calculate the sum and products

      iex>Day7.calculate([10,5,34], ["1","0"], 0)
      84
  """
  def calculate([_], [], sum), do: sum
  def calculate([first, second | tailNumbers], [operator | tail], sum) do
    case [operator, sum] do
      ["1", 0] -> calculate([second | tailNumbers], tail, sum + first * second)
      ["0", 0] -> calculate([second | tailNumbers], tail, sum + first + second)
      ["1", _] -> calculate([second | tailNumbers], tail, sum * second)
      ["0", _] -> calculate([second | tailNumbers], tail, sum + second)
    end
  end

  @doc """
  Recurse combinations of * and +
      iex> Day7.combinations([292,[11, 6, 16, 20]])
      292
      iex> Day7.combinations([42,[2,1,39]])
      42
      iex> Day7.combinations([161011, [16, 10, 13]])
      0
  """
  def combinations([_, _], counter, _) when counter == -1, do: 0
  def combinations([product, list], counter, length) do
    # String.graphemes
    case calculate(list, binaryToLength(counter, length) |> String.graphemes(), 0) == product do
    true -> product
    false -> combinations([product, list], counter-1, length)
    end
  end
  def combinations([product, list]) do
    # might have to count the number of digits needed * or + (*1,+0)
    # have a counter that it calls this function with those values and then build out a list of operators
    # [Integer.to_string(3, 2), Integer.to_string(243, 2)] ["11", "11110011"]
    numberOfOperators = length(list)-1
    combinations([product, list], (2**numberOfOperators)-1, numberOfOperators)
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
  ## Examples
      iex> {:ok, content} = File.read("sample.txt")
      iex> Day7.parts(content)
      3749

      iex> {:ok, content} = File.read("day7.txt")
      iex> Day7.parts(content)
      7579994664753
  """
  def parts(content) do
    content
      |> String.split("\n")
      |> Enum.map(fn entry -> parse(entry) end)
      |> Enum.map(fn row -> combinations(row) end)
      |> Enum.sum()
  end
end
