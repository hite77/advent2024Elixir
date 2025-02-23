defmodule Day6 do
  @moduledoc """
  Documentation for `Day6`.
  """

  @doc """
  Parse turns the split text to a map that can be accessed by [y,x]

      iex> {:ok, contents} = File.read("sample.txt")
      iex> contents |> Day6.parse()
      %{
              0 => %{0 => ".", 1 => ".", 2 => ".", 3 => ".", 4 => "#", 5 => ".", 6 => ".", 7 => ".", 8 => ".", 9 => "."},
              1 => %{0 => ".", 1 => ".", 2 => ".", 3 => ".", 4 => ".", 5 => ".", 6 => ".", 7 => ".", 8 => ".", 9 => "#"},
              2 => %{0 => ".", 1 => ".", 2 => ".", 3 => ".", 4 => ".", 5 => ".", 6 => ".", 7 => ".", 8 => ".", 9 => "."},
              3 => %{0 => ".", 1 => ".", 2 => "#", 3 => ".", 4 => ".", 5 => ".", 6 => ".", 7 => ".", 8 => ".", 9 => "."},
              4 => %{0 => ".", 1 => ".", 2 => ".", 3 => ".", 4 => ".", 5 => ".", 6 => ".", 7 => "#", 8 => ".", 9 => "."},
              5 => %{0 => ".", 1 => ".", 2 => ".", 3 => ".", 4 => ".", 5 => ".", 6 => ".", 7 => ".", 8 => ".", 9 => "."},
              6 => %{0 => ".", 1 => "#", 2 => ".", 3 => ".", 4 => "^", 5 => ".", 6 => ".", 7 => ".", 8 => ".", 9 => "."},
              7 => %{0 => ".", 1 => ".", 2 => ".", 3 => ".", 4 => ".", 5 => ".", 6 => ".", 7 => ".", 8 => "#", 9 => "."},
              8 => %{0 => "#", 1 => ".", 2 => ".", 3 => ".", 4 => ".", 5 => ".", 6 => ".", 7 => ".", 8 => ".", 9 => "."},
              9 => %{0 => ".", 1 => ".", 2 => ".", 3 => ".", 4 => ".", 5 => ".", 6 => "#", 7 => ".", 8 => ".", 9 => "."}
      }
  """
  def parse(contents) do
    # graphemes devides by letters and makes lists of letters
     contents |> String.split("\n")
              |> Enum.map(fn line -> String.graphemes(line) end)
     # next line fills map, it is streaming across list and adding number
              |> Enum.map(fn line->  Stream.with_index(line, 0) |> Enum.reduce(%{}, fn({v,k}, acc)-> Map.put(acc, k, v) end) end)
          #next line adds the other dimension.
              |> Stream.with_index(0) |> Enum.reduce(%{}, fn({v,k}, acc)-> Map.put(acc, k, v) end)
  end

   @doc """
  Extents finds the range of map
  ## Example

        iex>Day6.calculateExtents(%{0 => %{0 => "M", 1 => "M", 2 => "M", 3 => "S", 4 => "X", 5 => "X", 6 => "M", 7 => "A", 8 => "S", 9 => "M"}, 1 => %{0 => "M", 1 => "S", 2 => "A", 3 => "M", 4 => "X", 5 => "M", 6 => "S", 7 => "M", 8 => "S", 9 => "A"}, 2 => %{0 => "A", 1 => "M", 2 => "X", 3 => "S", 4 => "X", 5 => "M", 6 => "A", 7 => "A", 8 => "M", 9 => "M"}, 3 => %{0 => "M", 1 => "S", 2 => "A", 3 => "M", 4 => "A", 5 => "S", 6 => "M", 7 => "S", 8 => "M", 9 => "X"}, 4 => %{0 => "X", 1 => "M", 2 => "A", 3 => "S", 4 => "A", 5 => "M", 6 => "X", 7 => "A", 8 => "M", 9 => "M"}, 5 => %{0 => "X", 1 => "X", 2 => "A", 3 => "M", 4 => "M", 5 => "X", 6 => "X", 7 => "A", 8 => "M", 9 => "A"}, 6 => %{0 => "S", 1 => "M", 2 => "S", 3 => "M", 4 => "S", 5 => "A", 6 => "S", 7 => "X", 8 => "S", 9 => "S"}, 7 => %{0 => "S", 1 => "A", 2 => "X", 3 => "A", 4 => "M", 5 => "A", 6 => "S", 7 => "A", 8 => "A", 9 => "A"}, 8 => %{0 => "M", 1 => "A", 2 => "M", 3 => "M", 4 => "M", 5 => "X", 6 => "M", 7 => "M", 8 => "M", 9 => "M"}, 9 => %{0 => "M", 1 => "X", 2 => "M", 3 => "X", 4 => "A", 5 => "X", 6 => "M", 7 => "A", 8 => "S", 9 => "X"} })
        [10,10]
  """

  def calculateExtents(map) do
    y = length(Map.keys(map))
    x = length(Map.keys(map[0]))
    [y, x]
  end

  @doc """
  Find start position, need to look for character "^"
  Return [y,x] coords for it.

        iex> {:ok, contents} = File.read("sample.txt")
        iex> map = contents |> Day6.parse()
        iex> extents = Day6.calculateExtents(map)
        iex> Day6.findCharacter("^", map, extents, [0,0], map[0][0])
        [6, 4]

  """
  def findCharacter(character, _map, [_yextents, _xextents], [y ,x],  characterAtPosition) when characterAtPosition == character, do: [y,x]
  def findCharacter(character,  map, [ yextents,  xextents], [y ,x], _characterAtPosition) when y+1 <= yextents                 , do: findCharacter(character, map, [yextents, xextents], [y+1,   x], map[y+1][ x ])
  def findCharacter(character,  map, [ yextents,  xextents], [_y,x], _characterAtPosition)                                      , do: findCharacter(character, map, [yextents, xextents], [0  , x+1], map[ 0 ][x+1])

  @doc """
  Turn rotates 90 degrees

      iex>Day6.turn(:left)
      :up
      iex>Day6.turn(:up)
      :right
      iex>Day6.turn(:right)
      :down
      iex>Day6.turn(:down)
      :left
  """
  def turn(direction) when direction == :up , do: :right
  def turn(direction) when direction == :right , do: :down
  def turn(direction) when direction == :down , do: :left
  def turn(direction) when direction == :left , do: :up

  def characterFor(direction) when direction == :up, do: "^"
  def characterFor(direction) when direction == :right, do: ">"
  def characterFor(direction) when direction == :down, do: "v"
  def characterFor(direction) when direction == :left, do: "<"

  @doc """
  Calculate next step in direction -- -1 if next step would go out.

  """
  def oneStep([y , x], [ _,_ ], direction) when direction == :up                , do: [y-1,  x]
  def oneStep([y , x], [ _,_ ], direction) when direction == :right             , do: [y  ,x+1]
  def oneStep([y , x], [ _,_ ], direction) when direction == :down              , do: [ y+1, x]
  def oneStep([y , x], [ _,_ ], direction) when direction == :left              , do: [y , x-1]

  def countAllX(_map, [_yt,xt], [_y,x], _character, count) when x == xt,          do: count
  def countAllX(map, [yt,xt], [y,x], _character, count) when y == yt    ,          do: countAllX(map, [yt,xt], [0,x+1], map[0][x+1], count)
  def countAllX(map, [yt,xt], [y,x], character, count) do
    case character == "X" do
      true  -> countAllX(map, [yt,xt], [y+1,x], map[y+1][x], count + 1)
      false -> countAllX(map, [yt,xt], [y+1,x], map[y+1][x], count)
    end
  end

  def addToMap(y,x,char,map) do
    case x in Map.keys(map) do
      true -> Map.put(map, y, Map.put(map[y], x, char))
      false -> Map.put(map, y, Map.put(%{}, x, char))
    end
  end

  def scanForObstaclePlacement(_map, [_yt,xt], [_y,x], _character, count, [_gy,_gx]) when x == xt, do: count
  def scanForObstaclePlacement(map, [yt,xt], [y,x], _character, count, [gy,gx]) when y == yt, do: scanForObstaclePlacement(map, [yt,xt], [0,x+1], map[0][x+1], count,[gy,gx])
  def scanForObstaclePlacement(map, [yt,xt], [y,x], character, count, [gy,gx]) when character == "^" or character == "#", do: scanForObstaclePlacement(map, [yt,xt], [y+1,x], map[y+1][x], count, [gy,gx])
  def scanForObstaclePlacement(map, [yt,xt], [y,x], _character, count, [gy,gx]) do
    #check if this path is a closed loop +1 count if so and increment y.
    #make changes to map but don't return map.
    #will be similar to patrol, but will be patrol for loop...
    #TODO write out the obstacle to copied map
    cyclemap = map
    cyclemap = addToMap(y,x,"#",cyclemap)
    #returns 1, if cycle, otherwise 0.
    # "Welcome #{name}, your email is: #{email(username, domain)}"
    IO.puts("Scanning for solution for obstacle :Y#{y}, :X#{x} count:#{count}")
    count = count + patrolDetectCycle(cyclemap, [yt,xt], :up, [gy-1,gx], [gy,gx], characterFor(:up), cyclemap[gy][gx], [])
    IO.puts("Scanning for solution for obstacle :Y#{y}, :X#{x} count:#{count}")
    scanForObstaclePlacement(map, [yt,xt], [y+1,x], map[y+1][x], count ,[gy,gx])
  end

# iex(1)> list = []
# []
# iex(2)> list = [[1,2] | list]
# [[1, 2]]
# iex(3)> list = [[2,3] | list]
# [[2, 3], [1, 2]]
# iex(4)> [2,3] in list
# true
# iex(5)> [422,3] in list
# false
# iex(6)>


  #moved off map (4 ways to move off)
  def patrolDetectCycle(_cyclemap, [yt,_xt], _direction, [y,_x], [_gy,_gx], _characterFor, _characterAt, _movesList) when y == yt, do: 0
  def patrolDetectCycle(_cyclemap, [_yt,_xt], _direction, [y,_x], [_gy,_gx], _characterFor, _characterAt, _movesList) when y == -1, do: 0
  def patrolDetectCycle(_cyclemap, [_yt,xt], _direction, [_y,x], [_gy,_gx], _characterFor, _characterAt, _movesList) when x == xt, do: 0
  def patrolDetectCycle(_cyclemap, [_yt,_xt], _direction, [_y,x], [_gy,_gx], _characterFor, _characterAt, _movesList) when x == -1, do: 0
  #if same symbol, but also not the start position.
  # def patrolDetectCycle(_cyclemap, [_yt,_xt], _direction, [y,x], [gy,gx], characterFor, characterAt) when characterFor == characterAt, do: 1
  # def patrolDetectCycle(cyclemap,  [yt,xt]  , direction , [y,x], [gy,gx], characterFor, characterAt, movesList) when [y,x] in movesList, do: 1
  def patrolDetectCycle(cyclemap,  [yt,xt]  , direction , [y,x], [gy,gx], characterFor, characterAt, movesList) do
    # IMPORTANT -- map doesn't matter.... can probably swap to normal map. If I can have it check for dynamic obstacle.

    # IMPORTANT -- Need to record the position, and direction we were going when we hit a bumper, once a bumper comes up again, with same direction.
    case [y,x, direction] in movesList do
      true -> 1
      false ->
      # IO.puts("List: #{movesList}")
      # How do i detect the solution of one, and add 1?
      # case [y == gy, x == gx, characterAt == characterFor] do
        # [_, _, false] ->
      # cyclemap = addToMap(y,x,characterFor(direction), cyclemap)
      #hit obstacle (turn and move) -- otherwise move
      #once we turn, we need to check the other direction.
      #TODO: if infinite(or wrong answer) -- need to track where we have gone, and not care about characters.
      case mapAtOneStep([y,x], [yt,xt], direction, cyclemap) do
        "#" -> #At least one turn
             #record bumper position and direction....
             movesList = [[y,x, direction] | movesList]
             IO.puts("Adding: [#{y},#{x}]")
             direction = turn(direction)
            #  IO.puts("Direction")
            #  IO.puts(direction)
            #  IO.puts("Y:")
            #  IO.puts(y)
            #  IO.puts("X:")
            #  IO.puts(x)
            #  IO.puts("GY")
            #  IO.puts(gy)
            #  IO.puts("GX")
            #  IO.puts(gx)
             case mapAtOneStep([y,x], [yt,xt], direction, cyclemap) do
                "#" -> #Second turn
                      direction = turn(direction)
                      case mapAtOneStep([y,x], [yt,xt], direction, cyclemap) do
                        "#" -> #Third turn
                                direction = turn(direction)
                                case mapAtOneStep([y,x], [yt,xt], direction, cyclemap) do
                                  "#" -> 0 #Fourth turn
                                  _ -> patrolDetectCycle(cyclemap, [yt,xt], direction, oneStep([y,x],[yt,xt], direction ), [gy,gx], characterFor( direction ), cyclemap[y][x], movesList)
                                end
                        _ ->  patrolDetectCycle(cyclemap, [yt,xt], direction, oneStep([y,x],[yt,xt], direction ), [gy,gx], characterFor( direction ), cyclemap[y][x], movesList)
                      end
                _ ->  patrolDetectCycle(cyclemap, [yt,xt], direction, oneStep([y,x],[yt,xt], direction ), [gy,gx], characterFor( direction ), cyclemap[y][x], movesList)
             end
        _ ->  patrolDetectCycle(cyclemap, [yt,xt], direction, oneStep([y,x],[yt,xt], direction ), [gy,gx], characterFor( direction ), cyclemap[y][x], movesList)

        # "#" -> patrolDetectCycle(cyclemap, [yt,xt], turn(direction), oneStep([y,x],[yt,xt], turn(direction)), [gy,gx], characterFor(turn(direction)), cyclemap[y][x])
        # _  ->  patrolDetectCycle(cyclemap, [yt,xt],      direction,  oneStep([y,x],[yt,xt],      direction ), [gy,gx], characterFor(     direction ), cyclemap[y][x])
        end
      # [false, false, true] -> 0
      # [false, true, true] -> 0
      # end
    end
  end

  def patrol(map, [_yextents, _xextents], _direction, [y,_x]) when y == -1, do: map
  def patrol(map, [yextents, _xextents], _direction, [y,_x]) when y == yextents, do: map
  def patrol(map, [_yextents, _xextents], _direction, [_y,x]) when x == -1, do: map
  def patrol(map, [_yextents, xextents], _direction, [_y,x]) when x == xextents, do: map

  def patrol(map, [yextents, xextents], direction, [y,x]) do
    map = addToMap(y,x,"X",map)
    #hit obstacle (turn and move) -- otherwise move
    case mapAtOneStep([y,x], [yextents,xextents], direction, map) do
      "#" -> patrol(map, [yextents, xextents], turn(direction), oneStep([y,x],[yextents,xextents], turn(direction)))
      _  -> patrol(map, [yextents, xextents], direction, oneStep([y,x], [yextents,xextents], direction))
    end
  end

  def mapAtOneStep([y,x], [yt,xt], direction, map) do
    [ynext, xnext] = oneStep([y,x], [yt,xt], direction)
    case [ynext, xnext] do
      [-1,_] -> "."
      _      -> map[ynext][xnext]
    end
  end

  @doc """
  Part 1 -- scan in the map
         -- find "^"
         -- and move north (TODO)
         -- turn below obstactle (TODO)
         -- turn 90 clockwise each time an obstacle (TODO)
         -- start at 1, and count steps. (TODO)
         -- once he has left the field return count (TODO)
      iex> {:ok, contents} = File.read("sample.txt")
      iex> contents |> Day6.part1()
      41
  """
  def part1(contents) do
    map = contents |> parse()
    extents = calculateExtents(map)
    [y,x] = findCharacter("^", map, extents, [0,0], map[0][0])
    addToMap(y,x,"X",map) |> patrol(extents, :up, [y,x])
                          |> countAllX(extents, [0,0], map[0][0], 0)
  end

  @doc """
  Solve 1
      iex>Day6.solve1()
      4964
  """
  def solve1() do
    {:ok, contents} = File.read("day6.txt")
    contents |> part1()
  end
  @doc """
  Part 2
    iex> {:ok, contents} = File.read("sample.txt")
    iex> contents |> Day6.part2()
    6
  """
  def part2(contents) do
    map = contents |> parse()
    extents = calculateExtents(map)
    IO.puts("130 by 130")
    [y,x] = findCharacter("^", map, extents, [0,0], map[0][0])
    #TODO: scan where to place obstacle....(can't be ^, or #)
    #TODO: patrol but I need to detect when i start repeating the same direction
    #TODO: maybe write ^><v as directions moved. If it picks up that I've been there before
    #TODO: then count that one as a obstacle path.
    #TODO: if it exits the map, then it is not a repeatable one.
    scanForObstaclePlacement(map, extents, [0,0], map[0][0], 0, [y,x])
  end
  @doc """
  Solve 2
      iex>Day6.solve2()
      1740
  """
  def solve2() do
    {:ok, contents} = File.read("day6.txt")
    contents
      |> part2()
  end

end
