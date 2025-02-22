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
  Calculate next step in direction -- -1 if next step would go out.

  """
  def oneStep([y , _], [ _,_ ], direction) when direction == :up and y < 0     , do: [ -1, -1]
  def oneStep([y , x], [ _,_ ], direction) when direction == :up                , do: [y-1,  x]
  def oneStep([_ , x], [ _,xt], direction) when direction == :right and x == xt-1 , do: [ -1, -1]
  def oneStep([y , x], [ _,_ ], direction) when direction == :right             , do: [y  ,x+1]
  def oneStep([y, _ ], [yt,_ ], direction) when direction == :down and y == yt-1  , do: [ -1, -1]
  def oneStep([y , x], [ _,_ ], direction) when direction == :down              , do: [ y+1, x]
  def oneStep([_ , x], [ _,_ ], direction) when direction == :left and x < 0   , do: [ -1, -1]
  def oneStep([y , x], [ _,_ ], direction) when direction == :left              , do: [y , x-1]

  def countAllX(_map, [_yt,xt], [_y,x], _character, count) when x == xt,          do: count
  def countAllX(map, [yt,xt], [y,x], _character, count) when y == yt    ,          do: countAllX(map, [yt,xt], [0,x+1], map[0][x+1], count)
  def countAllX(map, [yt,xt], [y,x], character, count) do
    case character == "X" do
      true  -> countAllX(map, [yt,xt], [y+1,x], map[y+1][x], count + 1)
      false -> countAllX(map, [yt,xt], [y+1,x], map[y+1][x], count)
    end
  end

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

  def mapAtOneStep([y,x], [yt,xt], direction, map) do
    [ynext, xnext] = oneStep([y,x], [yt,xt], direction)
    case [ynext, xnext] do
      [-1,_] -> "."
      _      -> map[ynext][xnext]
    end
  end

  #              Y,X
  # map = addToMap(0,0,"X",map)

    #moved off map (4 ways to move off -- represented by -1,-1)
  def patrol(map, [_yextents, _xextents], _direction, [y,_x]) when y == -1, do: map
  def patrol(map, [yextents, xextents], direction, [y,x]) do
    map = addToMap(y,x,"X",map)
    #hit obstactle (turn and move) -- otherwise move
    case mapAtOneStep([y,x], [yextents,xextents], direction, map) do
      "#" -> patrol(map, [yextents, xextents], turn(direction), oneStep([y,x],[yextents,xextents], turn(direction)))
      _  -> patrol(map, [yextents, xextents], direction, oneStep([y,x], [yextents,xextents], direction))
    end
  end

  def addToMap(x,y,char,map) do
    case x in Map.keys(map) do
      true -> Map.put(map, x, Map.put(map[x], y, char))
      false -> Map.put(map, x, Map.put(%{}, y, char))
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
      :solve
  """
  def solve1() do
    {:ok, contents} = File.read("day6.txt")
    contents |> part1()
  end
end
