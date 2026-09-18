# lib/Roller/Resolvers/parser.ex
defmodule Roller.Resolvers.Parser do
  @doc """
  not sure if this is how it should be called, will update later maybe
  """

  def parser(_parent, %{tokens: tokens}, _resolution) do
    results =
      tokens
      |> String.split(",")
      |> Enum.map(&String.replace(&1, " ", ""))
      |> Enum.map(&evaluate_roll/1)
    {:ok, results}
  end


  def evaluate_roll(tokens) do
    rolled_tokens = 
      Regex.replace(~r/\d+d\d+/, tokens, fn match, _ ->
        rolled_value = roll_dice(match)
        Integer.to_string(rolled_value)
      end)
    {result, _} = Code.eval_string(rolled_tokens)
    result
  end
  
  @doc """
  Rolls a set of dice based on standard dice notation (e.g., "3d6").

  ## Parameters
  - `roll_string`: A string representing the dice roll in the format "countXsides" (e.g., "3d6").

  ## Logic
  It splits the string into the number of dice and the number of sides. 
  It then generates independent random numbers between 1 and the number of sides 
  for each die, and sums the results together.
  
  Sides is the size of the dice, times is the number of those dice
  so 3d6 is times = 3, sides = 6. 

  ## Examples
      iex> roll_dice("3d6")
      12
  """
  # use when roll_string contains a "d"
  def roll_dice(roll_string) do
    [times_to_roll, num_sides_dice] = String.split(roll_string, "d")
    times = String.to_integer(times_to_roll)
    sides =  String.to_integer(num_sides_dice)
    # roll the dice
    Enum.sum(for _ <- 1..times, do: Enum.random(1..sides))
  end
end
