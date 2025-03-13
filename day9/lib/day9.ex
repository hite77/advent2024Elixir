defmodule Day9 do
  @moduledoc """
  Documentation for `Day9`.
  """

  # Refactor whole app to write to single map representing ID number, or free space

  @doc """
  Put ID or some black indicator into Map
      iex>Day9.addToMap(0,0,%{})
      %{0 => 0}
      iex>Day9.addToMap(1,-1,%{0 => 0})
      %{0 => 0, 1 => -1}
  """
  def addToMap(x,code,map) do
    Map.put(map, x, code)
  end

  @doc """
  Should duplicate code (-1 for space)
  refactor out position, so that it keeps adding to the end of map. (count of keys + 1)
        iex>Day9.duplicate(3, 5, 0, %{})
        %{0 => 5, 1 => 5, 2 => 5}
        iex>Day9.duplicate(4, -1, 3, %{0 => 5, 1 => 5, 2 => 5})
        %{0 => 5, 1 => 5, 2 => 5, 3 => -1, 4 => -1, 5 => -1, 6 => -1}
  """
  def duplicate(0, _, _, map), do: map
  def duplicate(count, code, position, map), do: duplicate(count - 1, code, position + 1, addToMap(position, code, map))

  @doc """
  Parsing numbers
  Example:
  2333133121414131402 -- 00...111...2...333.44.5555.6666.777.888899

  length of file, length of free space
  12345
  one block file
  two block free
  three block file
  four blocks free
  five block file

  90909 -- three nine block files in a row, no free space

  12345
  0..111....22222 -- ids and dot for free

      iex>Day9.parse("12345")
      %{0 => 0, 1 => -1, 2 => -1, 3 => 1, 4 => 1, 5 => 1, 6 => -1, 7 => -1, 8 => -1, 9 => -1, 10 => 2, 11 => 2, 12 => 2, 13 => 2, 14 => 2}
      #this was more like the code and empty is -1.  [0,".",".",1,1,1,".",".",".",".",".",2,2,2,2,2]
      iex>Day9.parse("12")
      %{0 => 0, 1 => -1, 2 => -1}
      iex>Day9.parse("202020")
      %{0 => 0, 1 => 0, 2 => 1, 3 => 1, 4 => 2, 5 => 2}
      iex>Day9.parse("020202")
      %{0 => -1, 1 => -1, 2 => -1, 3 => -1, 4 => -1, 5 => -1}
      iex>Day9.parse("120110")
      %{0 => 0, 1 => -1, 2 => -1, 3 => -1, 4 => 2}

  """
  def parse([], _, _, map), do: map
  def parse([blocks], position, currentID, map), do: duplicate(blocks, currentID, position, map)
  def parse([blocks, free_blocks | tail], position, currentId, map) do
    map = duplicate(blocks, currentId, position, map)
    position = position + blocks
    map = duplicate(free_blocks, -1, position, map)
    position = position + free_blocks
    parse(tail, position, currentId + 1, map)
  end
  def parse(input) do
     input |> String.graphemes()
           |> Enum.map(fn item -> String.to_integer(item) end)
           |> parse(0,0, %{})
  end

  @doc """
  Moving over....
  The amphipod would like to move file blocks one at a time from the end of the disk to the leftmost free space block (until there are no gaps remaining between file blocks). For the disk map 12345, the process looks like this:

  0..111....22222
  02.111....2222.
  022111....222..
  0221112...22...
  02211122..2....
  022111222......

      iex>Day9.move(%{0 => 0, 1 => -1, 2 => -1, 3 => 1, 4 => 1, 5 => 1, 6 => -1, 7 => -1, 8 => -1, 9 => -1, 10 => 2, 11 => 2, 12 => 2, 13 => 2, 14 => 2})
      %{0 => 0, 1 => 2, 2 => 2, 3 => 1, 4 => 1, 5 => 1, 6 => 2, 7 => 2, 8 => 2, 9 => -1}

  00...111...2...333.44.5555.6666.777.888899
  009..111...2...333.44.5555.6666.777.88889. --> right most to first empty
  0099.111...2...333.44.5555.6666.777.8888.. --> keep going right, and also from the right
  00998111...2...333.44.5555.6666.777.888...
  009981118..2...333.44.5555.6666.777.88....
  0099811188.2...333.44.5555.6666.777.8.....
  009981118882...333.44.5555.6666.777.......
  0099811188827..333.44.5555.6666.77........
  00998111888277.333.44.5555.6666.7.........
  009981118882777333.44.5555.6666...........
  009981118882777333644.5555.666............
  00998111888277733364465555.66.............
  0099811188827773336446555566..............
  """
  def findLeftEmpty(left, map) do
    case [Map.get(map, left) == -1, left > Enum.max(Map.keys(map))] do
      [true, _] -> left
      [_, true] -> left + 1
      [false, false] -> findLeftEmpty(left + 1, map)
    end
  end
  def findRightNumber(right, map) do
    case [Map.get(map, right) != -1, right >= 0] do
      [true, _] -> right
      [_, false] -> -1
      [_, true] -> findRightNumber(right - 1, map)
    end
  end
  def move(left, right, map) do
    case left >= right do
      true -> map
      false ->  rightNumber = Map.get(map, right)
                leftNumber = Map.get(map, left)
                map = Map.put(map, left, rightNumber)
                map = Map.drop(map, [right])
                IO.puts("Left #{left}, Right #{right} Leftnumber #{leftNumber} RightNumber #{rightNumber}")
                newLeft = findLeftEmpty(left+1, map)
                newRight = findRightNumber(right-1, map)
                move(newLeft, newRight, map)
    end
  end
  def move(map) do
    newLeft = findLeftEmpty(0, map)
    newRight = findRightNumber(Enum.max(Map.keys(map)), map)
    move(newLeft, newRight, map)
  end

  @doc """
  Calculate checksum:
  position 0 is left most timed ID....
  skip free space (.)
  First example: 1928 for 0099811188827773336446555566..............
        iex>Day9.checksum(%{
        ...>      0 => 0,
        ...>      1 => 0,
        ...>      2 => 9,
        ...>      3 => 9,
        ...>      4 => 8,
        ...>      5 => 1,
        ...>      6 => 1,
        ...>      7 => 1,
        ...>      8 => 8,
        ...>      9 => 8,
        ...>      10 => 8,
        ...>      11 => 2,
        ...>      12 => 7,
        ...>      13 => 7,
        ...>      14 => 7,
        ...>      15 => 3,
        ...>      16 => 3,
        ...>      17 => 3,
        ...>      18 => 6,
        ...>      19 => 4,
        ...>      20 => 4,
        ...>      21 => 6,
        ...>      22 => 5,
        ...>      23 => 5,
        ...>      24 => 5,
        ...>      25 => 5,
        ...>      26 => 6,
        ...>      27 => 6,
        ...>      31 => -1,
        ...>      35 => -1})
        1928
  """
  # def checksum([], _, sum), do: sum
  #def checksum([head | _tail], _index, sum) when head == -1, do: sum
  #def checksum([head | tail], index, sum), do: checksum(tail, index + 1, sum + index * head)
  def checksum(map, index, sum) do
    case Enum.max(Map.keys(map)) > index do
      true -> value =  Map.get(map, index)
                case [value != -1, value == nil] do
                    [true, false] -> checksum(map, index + 1, sum + index * value)
                    [false, false] ->  IO.puts("-1 at index: #{index}")
                                       sum
                    [true, true]  ->   IO.puts("nil at index: #{index}")
                                       sum
                end
      false ->  IO.puts("Went past index")
                sum
    end
  end
  def checksum(map) do
    checksum(map, 0, 0)
    #Map.values(map)
    #  |> checksum(0,0)
  end

  @doc """
  Example:  equals 1928
      iex>{:ok, content} = File.read("example.txt")
      iex>Day9.parts(content)
      1928

      iex>{:ok, content} = File.read("day9.txt")
      iex>Day9.parts(content)
      6341711060162
      #8832372695439 too high. (113.5 seconds to get this result.)
      #8832372695439 still too high.
      #6341711060162 in 191.9 seconds -- 3.2 minutes.
      #5523 --> first time it hits -1 it stops summing, how did it have that low a total with -1.
      #Left 49780, Right 49784 Leftnumber -1 RightNumber 5298
      #Left 49781, Right 49783 Leftnumber -1 RightNumber 5298
      #What is at 49782 it likely can't be moved?

  """
  def parts(input) do
  input
      |> parse()
      |> move()
      |> checksum()
  end
end
