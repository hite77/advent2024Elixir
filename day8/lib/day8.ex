defmodule Day8 do
  @moduledoc """
  Documentation for `Day8`.
  """

  @doc """
  Parse pulls the grid out.
  First attempt may keep as lists so that I can scan, and also determine the extents.

  ## Examples
      iex> {:ok, content} = File.read("sample.txt")
      iex> Day8.parse(content)
      #  0    1    2    3    4    5    6    7    8    9   10    11
      [[".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."], #0
       [".", ".", ".", ".", ".", ".", ".", ".", "0", ".", ".", "."], #1
       [".", ".", ".", ".", ".", "0", ".", ".", ".", ".", ".", "."], #2
       [".", ".", ".", ".", ".", ".", ".", "0", ".", ".", ".", "."], #3
       [".", ".", ".", ".", "0", ".", ".", ".", ".", ".", ".", "."], #4
       [".", ".", ".", ".", ".", ".", "A", ".", ".", ".", ".", "."], #5
       [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."], #6
       [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."], #7
       [".", ".", ".", ".", ".", ".", ".", ".", "A", ".", ".", "."], #8
       [".", ".", ".", ".", ".", ".", ".", ".", ".", "A", ".", "."], #9
       [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."], #10
       [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."]] #11
  """
  def parse(content) do
    content
      |> String.split("\n")
      |> Enum.map(fn line -> String.graphemes(line) end)
  end

  @doc """
  Coliniearity will be next, need to find the coordinates for each letter in the grid, ignoring the . other than pushing extents.
  Y starts at top at 0.
      iex> {:ok, content} = File.read("sample.txt")
      iex> grid = Day8.parse(content)
      iex> Day8.coordsrows(grid, [], [0,0],0)
      [
        [
          ["A", 9, 9],
          ["A", 8, 8],
          ["A", 5, 6],
          ["0", 4, 4],
          ["0", 3, 7],
          ["0", 2, 5],
          ["0", 1, 8]
        ],[11,11]
      ]
  """
  def coordsrows([], coords, [y,x], _) ,do: [coords, [y,x]]
  def coordsrows([head | tail], coords, [y,x], row) do
   [coords, [y,x]] = coordscolumn(head, coords, [y,x], row, 0)
   coordsrows(tail, coords, [y,x], row+1)
  end

  def manageExtents([y,x], row,    _) when row > y, do: [y+1, x]
  def manageExtents([y,x], _, column) when column > x, do: [y, x+1]
  def manageExtents([y,x], _,      _), do: [y,x]

  def coordscolumn([head | tail], coords, [y,x], row, column) do
    case head == "." do
        true  -> coordscolumn(tail, coords, manageExtents([y,x], row, column), row, column+1)
        false -> coordscolumn(tail, [[head, row, column] | coords], manageExtents([y,x], row, column), row, column+1)
    end
  end
  def coordscolumn([], coords, [y,x], _, _), do: [coords, [y,x]]


  # Group the letters together -- might make things easier to manager, plus won't be calling a bunch of different letters.
  @doc """
  For Sample they happen to be grouped, but I need to keep processing and find all of a letter and get them together.
        iex>Day8.groupLetters([[["0", 4, 4],["A", 9, 9],["0", 3, 7],["A", 8, 8],["A", 5, 6],["0", 2, 5],["0", 1, 8]],[11,11]], [], [], "", [])
        [[[["A", 9, 9], ["A", 8, 8], ["A", 5, 6]], [["0", 1, 8], ["0", 2, 5], ["0", 3, 7], ["0", 4, 4]]], [11,11]]
  """
  def groupLetters([[], [y,x]], groupedList, [], _, currentGroup), do: [[currentGroup | groupedList], [y,x]]
  def groupLetters([[], [y,x]], groupedList, remainderList, _, currentGroup), do: groupLetters([remainderList, [y,x]],[currentGroup | groupedList], [], "", [])
  def groupLetters([[head | tail], [y,x]], groupedList, remainderList, currentLetter, currentGroup) do
    [letter, _, _] = head
    case [currentLetter == "", currentLetter == letter] do
      [true,     _ ] -> groupLetters([tail, [y,x]], groupedList, remainderList, letter, [head | currentGroup])
      [false, true ] -> groupLetters([tail, [y,x]], groupedList, remainderList, currentLetter, [head | currentGroup])
      [false, false] -> groupLetters([tail, [y,x]], groupedList, [head | remainderList], currentLetter, currentGroup)
    end
  end

  @doc """
  This should match up letters and get the coords of points on the grid.
  # [["A", 9, 9], ["A", 8, 8]]
    # if letters match --> generate two spots --> A1-A2 (y,x)  1,1 * 1 each... 1,1 add to a1 10,10
                                               #  A2-A1 (y,x)  -1,-1 * 1      -1,-1 add to a2 7,7
       #  0    1    2    3    4    5    6    7    8    9   10    11
  #    [[".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."], #0
  #     [".", ".", ".", ".", ".", ".", ".", ".", "0", ".", ".", "."], #1
  #     [".", ".", ".", ".", ".", "0", ".", ".", ".", ".", ".", "."], #2
  #     [".", ".", ".", ".", ".", ".", ".", "0", ".", ".", ".", "."], #3
  #     [".", ".", ".", ".", "0", ".", ".", ".", ".", ".", ".", "."], #4
  #     [".", ".", ".", ".", ".", ".", "A", ".", ".", ".", ".", "."], #5
  #     [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."], #6
  #     [".", ".", ".", ".", ".", ".", ".", "#", ".", ".", ".", "."], #7
  #     [".", ".", ".", ".", ".", ".", ".", ".", "$", ".", ".", "."], #8
  #     [".", ".", ".", ".", ".", ".", ".", ".", ".", "$", ".", "."], #9
  #     [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "#", "."], #10
  #     [".", ".", ".", ".", ".", ".", ".", ".", ".", ".", ".", "."]] #11
  """
  def colin([[], [_, _]], colinPoints), do: colinPoints
  def colin([[head | tail], [y,x]], colinPoints), do: colin([tail, [y,x]], colinLetter(head,head,[y,x],colinPoints))
  def colinLetter([head1 | tail1], list, [y,x], colinPoints), do:  colinItems(tail1, list, [y,x], colinItems(head1 , list, [y,x], colinPoints))
  def colinItems([_, _, _], [], _, colinPoints), do: colinPoints
  def colinItems([[letter, yi, xi] | tailItems], [head | tail], [y,x], colinPoints) do
    [_,yh,xh] = head
    colinItems(tailItems, [head | tail], [y,x],  colinItems([letter, yi, xi], tail, [y,x], build_colin(colinPoints, [y,x],[yi,xi],[yh,xh])))
  end
  def colinItems([], _, _, colinPoints), do: colinPoints
  def colinItems(item, [head | tail], [y,x], colinPoints) do
    [_, yi, xi] = item
    [_,yh,xh] = head
    colinItems(item, tail, [y,x], build_colin(colinPoints, [y,x], [yi,xi],[yh,xh]))
  end

  def build_colin(colinPoints, [yt,xt],[y1,x1],[y2,x2]) do
    case y1 == y2 and x1 == x2 do
      true -> colinPoints
      false -> first = [y1+(y1-y2)  ,x1+(x1-x2)]
               second = [y2+(y2-y1) ,x2+(x2-x1)]
               case [in_range([yt,xt], first), in_range([yt,xt], second)] do
                [true, true]   -> add_once(add_once(colinPoints, first), second)
                [true, false]  -> add_once(colinPoints, first)
                [false, true]  -> add_once(colinPoints, second)
                [false, false] -> colinPoints
               end
    end
  end

  def in_range([yt,xt], [y,x]) when y >= 0 and y<= yt and x>= 0 and x<= xt, do: true
  def in_range(_, _), do: false

  def add_once(colinPoints, [y,x]) do
    case [y,x] in colinPoints do
      true  -> colinPoints
      false -> [[y,x] | colinPoints]
    end
  end

@doc """
  Should be able to parse get the coords rows, and then calculate the Coliniearity

      iex> {:ok, content} = File.read("sample.txt")
      iex> Day8.parts(content)
      14

      iex> {:ok, content} = File.read("day8.txt")
      iex> Day8.parts(content)
      367

  """
  def parts(content) do
    content
      |> parse()
      |> coordsrows([], [0,0],0)
      |> groupLetters([], [], "", [])
      |> colin([])
      |> Enum.count()
  end

end
