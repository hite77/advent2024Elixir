defmodule Day3 do
  @moduledoc """
  Documentation for `Day3`.
  """

  @doc """
  Scan
  look for mul(<1-3 digit>,<1-3 digit>)
  ## Example

      iex> Day3.scan("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")
      [
        ["mul(2,4)", "2", "4"],
        ["mul(5,5)", "5", "5"],
        ["mul(11,8)", "11", "8"],
        ["mul(8,5)", "8", "5"]
      ]
  """
  def scan(text) do
    Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, text)
  end

  def convertNumber(firstNumber, secondNumber) do
    {firstNumber, _} = Integer.parse(firstNumber);
    {secondNumber, _} = Integer.parse(secondNumber);
    [firstNumber, secondNumber]
  end

  @doc """
  Convert Numbers

  ## Example
      iex> Day3.convertNumbers([["mul(2,4)", "2", "4"],["mul(5,5)", "5", "5"],["mul(11,8)", "11", "8"],["mul(8,5)", "8", "5"]])
      [[2, 4], [5, 5], [11, 8], [8, 5]]
  """
  def convertNumbers(data) do
    data |> Enum.map(fn [_ , second, third] -> convertNumber(second, third) end)
  end

  @doc """
  Example solution

      iex> Day3.part1("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")
      161
  """
  def part1(text) do
    text |> scan()
         |> convertNumbers()
         |> Enum.map(fn [firstNumber, secondNumber] -> firstNumber * secondNumber end)
         |> Enum.sum()
  end

  @doc """
  Solve part 1

      iex> Day3.solve1()
      179571322
  """
  def solve1() do
    {:ok, contents} = File.read("day3.txt")
    contents |> part1()
  end
end
