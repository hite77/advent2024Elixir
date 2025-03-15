defmodule Day10 do
  @moduledoc """
  Documentation for `Day10`.
  """

@doc """
    iex>Day10.addToMap([0,4],42, %{}, [])
    [%{0 => %{4 => 42}}, []]
    iex>Day10.addToMap([1,5], 56, %{0 => %{4 => 42}}, [])
    [%{0 => %{4 => 42}, 1 => %{5 => 56}}, []]
    iex>Day10.addToMap([1,6], 61, %{0 => %{4 => 42}, 1 => %{5 => 56}}, [])
    [%{0 => %{4 => 42}, 1 => %{5 => 56, 6 => 61}}, []]
    iex>Day10.addToMap([2,3], 0, %{0 => %{4 => 42}, 1 => %{5 => 56, 6 => 61}}, [])
    [%{0 => %{4 => 42}, 1 => %{5 => 56, 6 => 61}, 2 => %{3 => 0}}, [[[0, 2, 3]]]]

"""
def addToMap([y,x],char,map, listZero) do
  case [y in Map.keys(map), char == 0] do
    [true, true] -> [Map.put(map, y, Map.put(map[y], x, char)), [[[0, y, x]] | listZero]]
    [true, false] -> [Map.put(map, y, Map.put(map[y], x, char)), listZero]
    [false, false] -> [Map.put(map, y, Map.put(%{}, x, char)), listZero]
    [false, true] -> [Map.put(map, y, Map.put(%{}, x, char)), [[[0, y, x]] | listZero]]
  end
end

def addCells([], map, listZero,  _, _), do: [map, listZero]
def addCells([head | tail], map, listZero, currentRow, currentX) do
  [map, listZero] = addToMap([currentRow, currentX], head, map, listZero)
  addCells(tail, map, listZero, currentRow, currentX + 1)
end

def addRows([], map, listZero, _), do: [map, listZero]
def addRows([head | tail], map, listZero, currentRow) do
  [map, listZero] = addCells(head, map, listZero, currentRow, 0)
  addRows(tail, map, listZero, currentRow + 1)
end

  @doc """
  Parse into map
      iex>{:ok, content} = File.read("example.txt")
      iex>Day10.parse(content)
      [%{
              0 => %{0 => 8, 1 => 9, 2 => 0, 3 => 1, 4 => 0, 5 => 1, 6 => 2, 7 => 3},
              1 => %{0 => 7, 1 => 8, 2 => 1, 3 => 2, 4 => 1, 5 => 8, 6 => 7, 7 => 4},
              2 => %{0 => 8, 1 => 7, 2 => 4, 3 => 3, 4 => 0, 5 => 9, 6 => 6, 7 => 5},
              3 => %{0 => 9, 1 => 6, 2 => 5, 3 => 4, 4 => 9, 5 => 8, 6 => 7, 7 => 4},
              4 => %{0 => 4, 1 => 5, 2 => 6, 3 => 7, 4 => 8, 5 => 9, 6 => 0, 7 => 3},
              5 => %{0 => 3, 1 => 2, 2 => 0, 3 => 1, 4 => 9, 5 => 0, 6 => 1, 7 => 2},
              6 => %{0 => 0, 1 => 1, 2 => 3, 3 => 2, 4 => 9, 5 => 8, 6 => 0, 7 => 1},
              7 => %{0 => 1, 1 => 0, 2 => 4, 3 => 5, 4 => 6, 5 => 7, 6 => 3, 7 => 2}
            }, [[[0, 7, 1]], [[0, 6, 6]], [[0, 6, 0]], [[0, 5, 5]], [[0, 5, 2]], [[0, 4, 6]], [[0, 2, 4]], [[0, 0, 4]], [[0, 0, 2]]]]
  """
  def parse(content) do
   content
      |> String.split("\n")
      |> Enum.map(fn item -> String.graphemes(item) end)
      |> Enum.map(fn row -> Enum.map(row, fn item -> String.to_integer(item) end) end)
      |> addRows(%{}, [], 0)
  end

  @doc """
        iex>Day10.get([0,3], %{ 0 => %{0 => 8, 1 => 9, 2 => 0, 3 => 1, 4 => 0, 5 => 1, 6 => 2, 7 => 3}})
        1
        iex>Day10.get([1,3], %{ 0 => %{0 => 8, 1 => 9, 2 => 0, 3 => 1, 4 => 0, 5 => 1, 6 => 2, 7 => 3}})
        nil
        iex>Day10.get([1,42], %{ 0 => %{0 => 8, 1 => 9, 2 => 0, 3 => 1, 4 => 0, 5 => 1, 6 => 2, 7 => 3}})
        nil
  """
  def get([y,x], map) do
    mapy = Map.get(map, y)
    case mapy == nil do
      true -> nil
      false -> Map.get(mapy, x)
    end
  end

  @doc """
        iex>Day10.duplicate([[[9, 3, 4], [8, 4, 4], [7, 4, 3], [6, 4, 2], [5, 3, 2], [4, 3, 3], [3, 2, 3], [2, 1, 3], [1, 0, 3], [0, 0, 4]], [[9, 4, 5], [8, 4, 4], [7, 4, 3], [6, 4, 2], [5, 3, 2], [4, 3, 3], [3, 2, 3], [2, 1, 3], [1, 0, 3], [0, 0, 4]]], [[9, 4, 5], [8, 4, 4], [7, 4, 3], [6, 4, 2], [5, 3, 2], [4, 3, 3], [3, 2, 3], [2, 1, 3], [1, 0, 3], [0, 0, 4]])
        true
        iex>Day10.duplicate([[[9, 3, 4], [8, 4, 4], [7, 4, 3], [6, 4, 2], [5, 3, 2], [4, 3, 3], [3, 2, 3], [2, 1, 3], [1, 0, 3], [0, 0, 4]], [[9, 4, 6], [8, 4, 4], [7, 4, 3], [6, 4, 2], [5, 3, 2], [4, 3, 3], [3, 2, 3], [2, 1, 3], [1, 0, 3], [0, 0, 4]]], [[9, 4, 5], [8, 4, 4], [7, 4, 3], [6, 4, 2], [5, 3, 2], [4, 3, 3], [3, 2, 3], [2, 1, 3], [1, 0, 3], [0, 0, 4]])
        false
  """

  def duplicateCheckHead([], []), do: true
  def duplicateCheckHead([head | tail], [head2 | tail2]) do
    case head == head2 do
      true ->  duplicateCheckHead(tail, tail2)
      false -> false
    end
  end
  def duplicate([], _), do: false
  def duplicate([head | tail], item) do
    case duplicateCheckHead(head, item) do
      true -> true
      false -> duplicate(tail, item)
    end
  end

  def addOnce(trails, item) do
    case duplicate(trails, item) do
      true ->   trails
      false ->  [item | trails]
    end
  end
  def addUp(tail, head, heightOrNil, targetHeight, [y,x]) when heightOrNil == targetHeight, do: [[[targetHeight, y, x] | head] | tail]
  def addUp(tail, _, _, _, _), do: tail
  def buildTrails([_, []], trails), do: trails
  def buildTrails([map, [head | tail]], trails) do
    # head will have the complete trail.... for each one
    [head_coord | _] = head
    [height, y, x] = head_coord
    case height == 9 do
      true -> buildTrails([map, tail], addOnce(trails, head))
      false ->
        tail = addUp(tail, head, get([y+1, x], map), height + 1, [y+1,x])
        tail = addUp(tail, head, get([y-1, x], map), height + 1, [y-1,x])
        tail = addUp(tail, head, get([y, x+1], map), height + 1, [y,x+1])
        tail = addUp(tail, head, get([y, x-1], map), height + 1, [y,x-1])
        buildTrails([map, tail], trails)
    end

    #work off head, try and find up, left, right, down to see if one greater each direction
    #other paths get added to tail and then call score with new tail
  end

  def addUnique(item, coordinates) do
    case Enum.member?(coordinates, item) do
      true -> coordinates
      false -> [item | coordinates]
    end
  end
  def getZeroNine([], coordinates), do: coordinates
  def getZeroNine([head | tail], coordinates) do
    [number, y, x] = head
    case [number == 9, number == 0] do
     [true, false] -> getZeroNine(tail, [[number, y, x]])
     [false, true] -> getZeroNine(tail, [[number, y, x] | coordinates])
     [_, _]        -> getZeroNine(tail, coordinates)
   end
  end
  def filterUniqueTrails([], coordinates), do: coordinates
  def filterUniqueTrails([head | tail], coordinates) do
    # head is 0 -> 9 steps I only need Zero and 9 coordinate.
    filterUniqueTrails(tail, addUnique(getZeroNine(head, coordinates), coordinates))
  end
  @doc """
      iex>{:ok, content} = File.read("example.txt")
      iex>Day10.parts(content)
      36
      #81 is also too high. Was answer to part 2

      iex>{:ok, content} = File.read("example.txt")
      iex>Day10.part2(content)
      81

      iex>{:ok, content} = File.read("day10.txt")
      iex>Day10.parts(content)
      760
      #1764 is too high --> had to filter to unique 0, and 9 positions

      iex>{:ok, content} = File.read("day10.txt")
      iex>Day10.part2(content)
      1764

      iex>data = [
      ...>  [
      ...>    [9, 5, 4],
      ...>    [8, 4, 4],
      ...>    [7, 4, 3],
      ...>    [6, 4, 2],
      ...>    [5, 3, 2],
      ...>    [4, 3, 3],
      ...>    [3, 2, 3],
      ...>    [2, 1, 3],
      ...>    [1, 1, 2],
      ...>    [0, 0, 2]
      ...>  ],
      ...>  [
      ...>    [9, 3, 4],
      ...>    [8, 4, 4],
      ...>    [7, 4, 3],
      ...>    [6, 4, 2],
      ...>    [5, 3, 2],
      ...>    [4, 3, 3],
      ...>    [3, 2, 3],
      ...>    [2, 1, 3],
      ...>    [1, 1, 2],
      ...>    [0, 0, 2]
      ...>  ]]
      iex>data |> Enum.count()
      2
  """
  def parts(content) do
   content
      |> parse()
      |> buildTrails([])
      |> filterUniqueTrails([])
      |> Enum.count()
  end

  def part2(content) do
    content
      |> parse()
      |> buildTrails([])
      |> Enum.count()
  end
end
