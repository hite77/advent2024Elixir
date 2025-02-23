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
  def oneStep([y , x], direction) when direction == :up   , do: [y-1,  x]
  def oneStep([y , x], direction) when direction == :right, do: [y  ,x+1]
  def oneStep([y , x], direction) when direction == :down , do: [ y+1, x]
  def oneStep([y , x], direction) when direction == :left , do: [y , x-1]

  def countAllX(_map, [_yt,xt], [_y,x], _character, count) when x == xt, do: count
  def countAllX(map, [yt,xt], [y,x], _character, count) when y == yt   , do: countAllX(map, [yt,xt], [0,x+1], map[0][x+1], count)
  def countAllX(map, [yt,xt], [y,x], character, count) do
    case character == "X" do
      true  -> countAllX(map, [yt,xt], [y+1,x], map[y+1][x], count + 1)
      false -> countAllX(map, [yt,xt], [y+1,x], map[y+1][x], count)
    end
  end

  def addToMap([y,x],char,map) do
    case x in Map.keys(map) do
      true -> Map.put(map, y, Map.put(map[y], x, char))
      false -> Map.put(map, y, Map.put(%{}, x, char))
    end
  end

  def scanForObstaclePlacement(map ,   [yt,xt],   [gy,gx], [head | tail], count) do
    cyclemap = map

    cyclemap = addToMap(head,"#",cyclemap)
    count = count + patrolDetectCycle(cyclemap, [yt,xt], :up, [gy-1,gx], [gy,gx], [])
    scanForObstaclePlacement(map, [yt,xt],[gy,gx], tail, count)
  end
  def scanForObstaclePlacement(_map, [_yt,_xt], [_gy,_gx],       _     , count), do: count

  #moved off map (4 ways to move off)
  def patrolDetectCycle(_cyclemap, [yt,_xt], _direction, [y,_x], [_gy,_gx], _approachBumperPosition) when y == yt, do: 0
  def patrolDetectCycle(_cyclemap, [_yt,_xt], _direction, [y,_x], [_gy,_gx], _approachBumperPosition) when y == -1, do: 0
  def patrolDetectCycle(_cyclemap, [_yt,xt], _direction, [_y,x], [_gy,_gx], _approachBumperPosition) when x == xt, do: 0
  def patrolDetectCycle(_cyclemap, [_yt,_xt], _direction, [_y,x], [_gy,_gx], _approachBumperPosition) when x == -1, do: 0
  def patrolDetectCycle(cyclemap,  [yt,xt]  , direction , [y,x],  [gy,gx],   approachBumperPosition) do
    case [y,x, direction] in approachBumperPosition do
      true -> 1
      false ->
      #hit obstacle (turn and move) -- otherwise move
      case mapAtOneStep([y,x], direction, cyclemap) do
        "#" -> #At least one turn
             approachBumperPosition = [[y,x, direction] | approachBumperPosition]
             direction = turn(direction)
             case mapAtOneStep([y,x], direction, cyclemap) do
                "#" -> #Second turn
                      direction = turn(direction)
                      case mapAtOneStep([y,x], direction, cyclemap) do
                        "#" -> #Third turn
                                direction = turn(direction)
                                case mapAtOneStep([y,x], direction, cyclemap) do
                                  "#" -> 0 #Fourth turn
                                  _ -> patrolDetectCycle(cyclemap, [yt,xt], direction, oneStep([y,x], direction ), [gy,gx], approachBumperPosition)
                                end
                        _ ->  patrolDetectCycle(cyclemap, [yt,xt], direction, oneStep([y,x], direction ), [gy,gx], approachBumperPosition)
                      end
                _ ->  patrolDetectCycle(cyclemap, [yt,xt], direction, oneStep([y,x], direction ), [gy,gx], approachBumperPosition)
             end
        _ ->  patrolDetectCycle(cyclemap, [yt,xt], direction, oneStep([y,x], direction ), [gy,gx], approachBumperPosition)
        end

    end
  end

  def addOnce(item, list, guard) when item == guard, do: list
  def addOnce(item, list, _guard) do
    case item in list do
      true -> list
      false -> [item | list]
    end
  end

  def patrolAndStore(_map, [_yextents, _xextents], _direction, [y,_x], _guard, listOfPositionsX) when y == -1, do: listOfPositionsX
  def patrolAndStore(_map, [yextents, _xextents], _direction, [y,_x], _guard, listOfPositionsX) when y == yextents, do: listOfPositionsX
  def patrolAndStore(_map, [_yextents, _xextents], _direction, [_y,x], _guard, listOfPositionsX) when x == -1, do: listOfPositionsX
  def patrolAndStore(_map, [_yextents, xextents], _direction, [_y,x], _guard, listOfPositionsX) when x == xextents, do: listOfPositionsX
  def patrolAndStore(map,   [yextents, xextents],  direction,  [y,x],  guard, listOfPositionsX) do
    #hit obstacle (turn and move) -- otherwise move
    case mapAtOneStep([y,x], direction, map) do
      "#" -> patrolAndStore(map, [yextents, xextents], turn(direction), oneStep([y,x], turn(direction)), guard, addOnce([y,x], listOfPositionsX, guard ))
      _   -> patrolAndStore(map, [yextents, xextents], direction,       oneStep([y,x],      direction),  guard, addOnce([y,x], listOfPositionsX, guard ))
    end
  end

  def mapAtOneStep([y,x], direction, map) do
    [ynext, xnext] = oneStep([y,x], direction)
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

         -- reengineering.
      iex> {:ok, contents} = File.read("sample.txt")
      iex> contents |> Day6.parts()
      [:part1, 41, :part2, 6]
  """
  def parts(contents) do
    map = contents |> parse()
    extents = calculateExtents(map)
    [y,x] = findCharacter("^", map, extents, [0,0], map[0][0])
    xlocations = map |> patrolAndStore(extents, :up, [y+1,x], [y,x], [])
    part1 = xlocations |> Enum.count()
    part1 = part1 + 1 # Add guard position into count.

    #use xlocations here.
    #part2 = scanForObstaclePlacement(map, extents, [0,0], map[0][0], 0, [y,x])
    part2 = scanForObstaclePlacement(map, extents, [y,x], xlocations, 0)
    [:part1, part1, :part2, part2]
    #TODO: start working on using xlocations to make part 2 easier and possibly faster.

  end

  @doc """
  Solve 1
      iex>Day6.solve()
      [:part1, 4964, :part2, 1740]
  """
  def solve() do
    {:ok, contents} = File.read("day6.txt")
    contents |> parts()
  end

end
