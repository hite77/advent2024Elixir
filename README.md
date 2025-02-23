# advent2024Elixir
Working through examples using elixir.

mix new <name>
mix test

The following has no timeout, also indicates the time and name of each test.
mix test --trace

iex(1)> list = []
[]
iex(2)> list = [[1,2] | list]
[[1, 2]]
iex(3)> list = [[2,3] | list]
[[2, 3], [1, 2]]
iex(4)> [2,3] in list
true
iex(5)> [422,3] in list
false
iex(6)>

@doc """
  Hello world.

  ## Examples

      iex> Day5.hello()
      :world

  """

Doc testing even for solutions, and intermediate methods.

Map is used on day 4, plus might want to solve the eight way through finding X's and going each of the 8 ways to count them.
ALso day 6 has a floor layout / maze kinda.

Day 3 want to work out the solution of do() don't() so that I didn't have to write out an intermediate version, and also manually edit part of it out.

I need good example of reduce....
def commonLetter({first, second}) do
    list = String.graphemes(first)
    Enum.reduce(list, "", fn (character, output) -> characterContained(character, second, output) end)
  end

^^^^^^ I think it has starting values, and then colecting those together and building the output.

Below is what put the grid of letters into a map, and then used map operators to access the coordinates like a grid.
 def parse(text) do
    # graphemes devides by letters and makes lists of letters
     text |> Enum.map(fn line -> String.graphemes(line) end)
     # next line fills map, it is streaming across list and adding number
          |> Enum.map(fn line->  Stream.with_index(line, 0) |> Enum.reduce(%{}, fn({v,k}, acc)-> Map.put(acc, k, v) end) end)
          #next line adds the other dimension.
          |> Stream.with_index(0) |> Enum.reduce(%{}, fn({v,k}, acc)-> Map.put(acc, k, v) end)
  end
