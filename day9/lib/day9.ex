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
  Move by clocks.

  # Start with right most number --> 9 in this case
  # find start to end of moving block all should be 9
  # Looking for 2 blocks free from the left....
  # stop looking for moving the number if nothing is found big enough (-1's)
  # replace start to end (9) with -1
  # replace start to end of left replace with 9....
  # call move2 with next lower ID -- find it's start and end (length) -- find if space available and move.

  00...111...2...333.44.5555.6666.777.888899
  0099.111...2...333.44.5555.6666.777.8888..
  0099.1117772...333.44.5555.6666.....8888..
  0099.111777244.333....5555.6666.....8888..
  00992111777.44.333....5555.6666.....8888..
    iex>{:ok, content} = File.read("example.txt")
    iex>content |> Day9.parse() |> Day9.move2()
    %{0 => 0, 1 => 0, 2 => 9, 3 => 9, 4 => 2, 5 => 1, 6 => 1, 7 => 1, 8 => 7, 9 => 7, 10 => 7, 11 => -1, 12 => 4, 13 => 4, 14 => -1, 15 => 3, 16 => 3, 17 => 3, 18 => -1, 19 => -1, 20 => -1, 21 => -1, 22 => 5, 23 => 5, 24 => 5, 25 => 5, 26 => -1, 27 => 6, 28 => 6, 29 => 6, 30 => 6, 31 => -1, 32 => -1, 33 => -1, 34 => -1, 35 => -1, 36 => 8, 37 => 8, 38 => 8, 39 => 8, 40 => -1, 41 => -1}
  """
  def copy(map, id, startId, endId, startEmpty, endEmpty) do
    case startId > endId do
      true -> map
      false -> map = Map.put(map, startId, -1)
               map = Map.put(map, startEmpty, id)
               copy(map, id, startId + 1, endId, startEmpty + 1, endEmpty)
    end
  end
  def move2([], map), do: map
  def move2([head | tail], map) do
    [id, startId, endId, length] = head
    IO.puts("Current Id: #{id} startId: #{startId} endId: #{endId} length: #{length}")
    [startEmpty, endEmpty, found] = findSpaceForNumber(map, length, startId, 0, -1)
    case found do
      false -> move2(tail, map)
      true -> move2(tail, copy(map, id, startId, endId, startEmpty, endEmpty))
    end
  end
  def move2(map), do: move2(group(map), map)

  #0, 0, -1, -1, -1, 1, 1,
  # ASK FOR LENGTH 4
  @doc """
  Find space for number
        iex>map = %{0 => 0, 1 => -1, 2 => -1, 3 => 1, 4 => -1, 5 => -1, 6 => -1}
        iex>Day9.findSpaceForNumber(map, 1, 6, 0, -1)
        [1,1, true]
        iex>Day9.findSpaceForNumber(map, 2, 6, 0, -1)
        [1,2, true]
        iex>Day9.findSpaceForNumber(map, 3, 7, 0, -1)
        [4,6, true]
        iex>Day9.findSpaceForNumber(map, 3, 5, 0, -1)
        [0,0, false]
  """
  # Call map, length 1, 6 end search, 0 current position, currentlengthSpace = -1
  # case [false, 0, true, false]
  # call map, 1, 6, 1, -1
  # case [false, -1, true, false]
  def findSpaceForNumber(map, length, endOfSearchPosition, currentPosition, currentlengthSpace) do
    case [currentPosition >= endOfSearchPosition, Map.get(map, currentPosition), currentlengthSpace == -1, currentlengthSpace == length] do
      [_, _, _, true] -> [currentPosition - length + 1,  currentPosition, true]
      [true, _, _, _] -> [0,0,false]
      [false, -1, true, _] -> case length == 1 do
                              false -> findSpaceForNumber(map, length, endOfSearchPosition, currentPosition + 1, 1)
                              true -> [currentPosition, currentPosition, true]
                              end
      [false, -1, false, _] -> case length == currentlengthSpace + 1 do
                               false -> findSpaceForNumber(map, length, endOfSearchPosition, currentPosition + 1, currentlengthSpace + 1)
                               true -> [currentPosition - length + 1,  currentPosition, true]
                               end

      [_, _, _, _] -> findSpaceForNumber(map, length, endOfSearchPosition, currentPosition + 1, -1)
    end
  end

  @doc """
        iex>Day9.group(%{0 => 0, 1 => 0, 2 => -1, 3 => 1, 4 => 2, 5 => 2, 6 => 2})
        [[2, 4, 6, 3], [1, 3, 3, 1], [0, 0, 1, 2]]

        iex>Day9.group(%{0 => -1, 1 => 0, 2 => 0, 3 => -1, 4 => 1, 5 => 2, 6 => 2, 7 => 2})
        [[2, 5, 7, 3], [1, 4, 4, 1], [0, 1, 2, 2]]

        iex>Day9.group(%{
        ...>      0 => 0, #[0,0,1,2]
        ...>      1 => 0,
        ...>      2 => -1,
        ...>      3 => -1,
        ...>      4 => -1,
        ...>      5 => 1, #[1, 5, 7, 3]
        ...>      6 => 1,
        ...>      7 => 1,
        ...>      8 => -1,
        ...>      9 => -1,
        ...>      10 => -1,
        ...>      11 => 2, #[2, 11, 11, 1]
        ...>      12 => -1,
        ...>      13 => -1,
        ...>      14 => -1,
        ...>      15 => 3, #[3, 15, 17, 3]
        ...>      16 => 3,
        ...>      17 => 3,
        ...>      18 => -1,
        ...>      19 => 4, #[4, 19, 20, 2]
        ...>      20 => 4,
        ...>      21 => -1,
        ...>      22 => 5, #[5, 22, 25, 4]
        ...>      23 => 5,
        ...>      24 => 5,
        ...>      25 => 5,
        ...>      26 => -1,
        ...>      27 => 6, #[6, 27, 30, 4]
        ...>      28 => 6,
        ...>      29 => 6,
        ...>      30 => 6,
        ...>      31 => -1,
        ...>      32 => 7, #[7, 32, 34, 3]
        ...>      33 => 7,
        ...>      34 => 7,
        ...>      35 => -1,
        ...>      36 => 8, #[8, 36, 39, 4]
        ...>      37 => 8,
        ...>      38 => 8,
        ...>      39 => 8,
        ...>      40 => 9, #[9, 40, 41, 2]
        ...>      41 => 9
        ...>    })
        [[9, 40, 41, 2], [8, 36, 39, 4], [7, 32, 34, 3], [6, 27, 30, 4], [5, 22, 25, 4], [4, 19, 20, 2], [3, 15, 17, 3], [2, 11, 11, 1], [1, 5, 7, 3], [0, 0, 1, 2]]
  """
  # return [[ID, start, end, length], next
  def group(map, position, currentId, start, endCode, groupings) do
    currentPos = Map.get(map, position)
    case [currentPos, currentId == -1, start == -1, currentPos == currentId] do
      [nil, false, false, _]  -> [[currentId, start, endCode, endCode - start + 1] | groupings]
      [-1,  true, true, true] -> group(map, position + 1, currentId, start, endCode, groupings)
      [-1,  false, false, false] -> group(map, position + 1, -1, -1, -1, [[currentId, start, endCode, endCode - start + 1] | groupings])
      #currentId = -1, it is an integer
      [_, true, true, false] -> start = position
                                endCode = position
                                group(map, position + 1, currentPos, start, endCode, groupings)
      # Has Id, Start set , continue
      [_, false, false, true] -> endCode = position
                                 group(map, position + 1, currentId, start, endCode, groupings)
      #  Has ID, start, not matching
      [_, false, false, false] -> groupings = [[currentId, start, endCode, endCode - start + 1] | groupings]
                                  group(map, position + 1, currentPos, position, position, groupings)
    end
  end
  def group(map), do: group(map, 0, -1, -1, -1, [])

  # TODO: try this idea, and refactor Find Number to be simpler, or just send it in to move and traverse it.
  # Might want to create a list of tuples with ID and start, end and length and build it so that head is highest id.
  # I can traverse this with Find Number or might just be popping the head off and keep working through till it is empty.

  # Probably don't do this part.... Might want to create another list of spaces?  Except each move would invalidate it --

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
  end

  def checksum2(map, index, sum) do
    IO.puts("index: #{index}")
    case Enum.max(Map.keys(map)) >= index do
      true -> value =  Map.get(map, index)
                case [value != -1, value == nil] do
                    [true, false] -> checksum2(map, index + 1, sum + index * value)
                    [false, false] ->  checksum2(map, index + 1, sum)
                    [true, true]  ->   IO.puts("nil at index: #{index}")
                                       sum
                end
      false ->  IO.puts("Went past index")
                sum
    end
  end
  def checksum2(map) do
    checksum2(map, 0, 0)
  end

  @doc """
  Example:  equals 1928
      iex>{:ok, content} = File.read("example.txt")
      iex>Day9.parts(content)
      1928

      #iex>{:ok, content} = File.read("day9.txt")
      #iex>Day9.parts(content)
      #6341711060162

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
@doc """
      iex>{:ok, content} = File.read("example.txt")
      iex>Day9.part2(content)
      2858
      iex>{:ok, content} = File.read("day9.txt")
      iex>Day9.part2(content)
      6377400869326
"""
  def part2(input) do
    input
      |> parse()
      |> move2()
      |> checksum2()
  end
end
