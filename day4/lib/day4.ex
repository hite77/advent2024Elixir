defmodule Day4 do
  @moduledoc """
  Documentation for `Day4`.
  """

  def parse(text) do
    # graphemes devides by letters and makes lists of letters
     text |> Enum.map(fn line -> String.graphemes(line) end)
     # next line fills map, it is streaming across list and adding number
          |> Enum.map(fn line->  Stream.with_index(line, 0) |> Enum.reduce(%{}, fn({v,k}, acc)-> Map.put(acc, k, v) end) end)
          #next line adds the other dimension.
          |> Stream.with_index(0) |> Enum.reduce(%{}, fn({v,k}, acc)-> Map.put(acc, k, v) end)
  end

  @doc """
  Extents finds the range of map
  ## Example

        iex>Day4.calculateExtents(%{0 => %{0 => "M", 1 => "M", 2 => "M", 3 => "S", 4 => "X", 5 => "X", 6 => "M", 7 => "A", 8 => "S", 9 => "M"}, 1 => %{0 => "M", 1 => "S", 2 => "A", 3 => "M", 4 => "X", 5 => "M", 6 => "S", 7 => "M", 8 => "S", 9 => "A"}, 2 => %{0 => "A", 1 => "M", 2 => "X", 3 => "S", 4 => "X", 5 => "M", 6 => "A", 7 => "A", 8 => "M", 9 => "M"}, 3 => %{0 => "M", 1 => "S", 2 => "A", 3 => "M", 4 => "A", 5 => "S", 6 => "M", 7 => "S", 8 => "M", 9 => "X"}, 4 => %{0 => "X", 1 => "M", 2 => "A", 3 => "S", 4 => "A", 5 => "M", 6 => "X", 7 => "A", 8 => "M", 9 => "M"}, 5 => %{0 => "X", 1 => "X", 2 => "A", 3 => "M", 4 => "M", 5 => "X", 6 => "X", 7 => "A", 8 => "M", 9 => "A"}, 6 => %{0 => "S", 1 => "M", 2 => "S", 3 => "M", 4 => "S", 5 => "A", 6 => "S", 7 => "X", 8 => "S", 9 => "S"}, 7 => %{0 => "S", 1 => "A", 2 => "X", 3 => "A", 4 => "M", 5 => "A", 6 => "S", 7 => "A", 8 => "A", 9 => "A"}, 8 => %{0 => "M", 1 => "A", 2 => "M", 3 => "M", 4 => "M", 5 => "X", 6 => "M", 7 => "M", 8 => "M", 9 => "M"}, 9 => %{0 => "M", 1 => "X", 2 => "M", 3 => "X", 4 => "A", 5 => "X", 6 => "M", 7 => "A", 8 => "S", 9 => "X"} })
        [10,10]
  """

  def calculateExtents(map) do
    y = length(Map.keys(map))
    x = length(Map.keys(map[0]))
    [y, x]
  end

  def coordinatesForDirection([y,x], direction) do
    case direction do
      :umatch -> [y-1,x]
      :dmatch -> [y+1,x]
      :lmatch -> [y,x-1]
      :rmatch -> [y,x+1]
      :ulmatch -> [y-1,x-1]
      :urmatch -> [y-1,x+1]
      :dlmatch -> [y+1,x-1]
      :drmatch -> [y+1,x+1]
    end
  end

  def indexMapAtPosition([y,x], direction, maps) do
    [newy, newx] = coordinatesForDirection([y,x], direction)
    maps[newy][newx]
  end

#XMAS

# Scan through grid
def scan(maps , [yextents, xextents], [y,x], count) when x+1 <=xextents,                     do: findx(maps, [yextents, xextents], [y,x+1], count, maps[y][x+1])
def scan(maps , [yextents, xextents], [y,x], count) when x+1 > xextents and y+1 <= yextents, do: findx(maps, [yextents, xextents], [y+1,0], count, maps[y+1][0])
def scan(_maps, [yextents, xextents], [y,x], count) when x+1 > xextents and y+1 > yextents,  do: count

# Found first letter
def findx(maps, [yextents, xextents], [y,x], count, characterAtPosition) when characterAtPosition == "X"  do
  count_up    = find(maps, "M", [yextents, xextents], coordinatesForDirection([y,x],:umatch),  :umatch ,       count, indexMapAtPosition([y,x],:umatch,maps))
  count_down  = find(maps, "M", [yextents, xextents], coordinatesForDirection([y,x],:dmatch),  :dmatch ,    count_up, indexMapAtPosition([y,x],:dmatch,maps))
  count_left  = find(maps, "M", [yextents, xextents], coordinatesForDirection([y,x],:lmatch),  :lmatch ,  count_down, indexMapAtPosition([y,x],:lmatch,maps))
  count_right = find(maps, "M", [yextents, xextents], coordinatesForDirection([y,x],:rmatch),  :rmatch ,  count_left, indexMapAtPosition([y,x],:rmatch,maps))
  count_ul    = find(maps, "M", [yextents, xextents], coordinatesForDirection([y,x],:ulmatch), :ulmatch, count_right, indexMapAtPosition([y,x],:ulmatch,maps))
  count_ur    = find(maps, "M", [yextents, xextents], coordinatesForDirection([y,x],:urmatch), :urmatch,    count_ul, indexMapAtPosition([y,x],:urmatch,maps))
  count_dl    = find(maps, "M", [yextents, xextents], coordinatesForDirection([y,x],:dlmatch), :dlmatch,    count_ur, indexMapAtPosition([y,x],:dlmatch,maps))
  count_dr    = find(maps, "M", [yextents, xextents], coordinatesForDirection([y,x],:drmatch), :drmatch,    count_dl, indexMapAtPosition([y,x],:drmatch,maps))
  scan(maps, [yextents, xextents], [y,x], count_dr)
end
def findx(maps, [yextents, xextents], [y,x], count, _), do: scan(maps, [yextents, xextents], [y,x], count)

def find(maps, character, [yextents, xextents], [y,x], direction, count, characterAtPosition) when characterAtPosition == character and character == "M" do
  find(maps, "A", [yextents, xextents], coordinatesForDirection([y,x],direction), direction, count, indexMapAtPosition([y,x],direction,maps))
end
def find(maps, character, [yextents, xextents], [y,x], direction, count, characterAtPosition) when characterAtPosition == character and character == "A" do
  find(maps, "S", [yextents, xextents], coordinatesForDirection([y,x],direction), direction, count, indexMapAtPosition([y,x],direction,maps))
end
def find(_maps, character, [_yextents, _xextents], [_y,_x], _direction, count, characterAtPosition) when characterAtPosition == character and character == "S", do: count + 1
def find(_maps, character, [_yextents, _xextents], [_y,_x], _direction, count, characterAtPosition) when characterAtPosition != character, do: count
# Out of bounds
def find(_maps, _character, [yextents,  _xextents], [y, _x], _direction, count, _characterAtPosition) when y > yextents, do: count
def find(_maps, _character, [_yextents, _xextents], [y, _x], _direction, count, _characterAtPosition) when y < 0, do: count
def find(_maps, _character, [_yextents,  xextents], [_y, x], _direction, count, _characterAtPosition) when x > xextents, do: count
def find(_maps, _character, [_yextents, _xextents], [_y, x], _direction, count, _characterAtPosition) when x < 0, do: count
  @doc """

  Part 1
      iex> Day4.part1(["MMMSXXMASM", "MSAMXMSMSA", "AMXSXMAAMM", "MSAMASMSMX", "XMASAMXAMM", "XXAMMXXAMA", "SMSMSASXSS", "SAXAMASAAA", "MAMMMXMMMM", "MXMXAXMASX"])
      18
  """
def part1(lines) do
  maps = lines |> parse()
  extents = calculateExtents(maps)
  #          Look for       Pos at 0,0
  findx(maps, extents, [0,0], 0, maps[0][0])
end

  @doc """
  Solve1

      iex> Day4.solve()
      2534
  """
  def solve() do
    {:ok, contents} = File.read("day4.txt")
    String.split(contents, "\n", trim: true)
             |> part1()
  end
end
