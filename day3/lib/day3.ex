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
      iex> Day3.scan("mul(1000,1000)mul(10,10)")
      [["mul(10,10)","10","10"]]
  """
  def scan(text) do
    Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, text)
  end

  @doc """
  Don't to Do should be removed, plus remove Don't to end of line as well.

      iex> Day3.removeDont("1234don't()not thisdo()56789don't()not this eitherdo()10")
      "1234don't(56789don't(10"
      iex> Day3.removeDont("don't()notthisdo()thisdo()butthisdon't()not")
      "don't(thisdo()butthisdon't("
      iex> Day3.removeDont("don't()notthisdon't()or thisdo()butthisdon't()not")
      "don't(butthisdon't("
      iex> Day3.removeDont("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")
      "xmul(2,4)&mul[3,7]!^don't(?mul(8,5))"
      iex> Day3.removeDont("do()12do()23don't()NoneOfThisdon't()notdo()hello")
      "do()12do()23don't(hello"
      iex> Day3.removeDont("this showsdon't()end")
      "this showsdon't("
      iex> Day3.removeDont("12don't()anythingdon't()thisalsodo()34")
      "12don't(34"
      iex> Day3.removeDont("12don't()fdfsdfdo()fdfsfdsdo()123")
      "12don't(fdfsfdsdo()123"
      iex> Day3.removeDont("sometextdo()moredo()evenmoredon't()notthis")
      "sometextdo()moredo()evenmoredon't("
      iex> Day3.removeDont("adon't()notthisdo()greedymightnotleavethisdo()")
      "adon't(greedymightnotleavethisdo()"
  """
  def pieces([], list, _enabled, _command), do: list
  def pieces([head | tail], list, enabled, command) do
  # Keep building command
    command = command <> head
    case [enabled, String.contains?(command,"do()"), String.contains?(command, "don't()")] do
      [true, _, true] -> enabled = false
                         command = ""
                         pieces(tail, list, enabled, command)
      [true, _, false] ->
        [head | pieces(tail, list, enabled, command)]
      [false,true, _]  -> enabled = true
                          command = ""
                          pieces(tail, list, enabled, command)
      [false,false,_]  -> pieces(tail, list, enabled, command)
    end
  end
  def removeDont(text) do
    pieces(String.split(text, "", trim: true), [], true, "")
      |> Enum.join("")
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
      iex> Day3.convertNumbers([["mul(-1,5)", "-1", "5"]])
      [[-1, 5]]
  """
  def convertNumbers(data) do
    data |> Enum.map(fn [_ , second, third] -> convertNumber(second, third) end)
  end

  @doc """
  Example solution

      iex> Day3.part1("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")
      161
  """
  def common(text) do
    text |> scan()
         |> convertNumbers()
         |> Enum.map(fn [firstNumber, secondNumber] -> firstNumber * secondNumber end)
         |> Enum.sum()
  end

  def part1(text) do
    text |> common()
  end

  @doc """
  Example solution
      iex> Day3.part2("xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))")
      48

  """
  def part2(text) do
    text
      |> removeDont()
        |> common()
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

  @doc """
  Solve part 2 -- 105264641 is too high.
                  105264641 -- still getting this answer.
                  103811193 -- this is correct fix the parsing to find why.
                  106494365 even higher with just getting rid of don't to do

      iex> Day3.solve2()
      103811193
  """
  def solve2() do
    {:ok, contents} = File.read("day3.txt")
    contents |> part2()
  end
end
