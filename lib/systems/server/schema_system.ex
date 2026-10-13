# lib/systems/server/schema_system.ex
defmodule Systems.Schema do
  use Absinthe.Schema

  alias Systems.MakeRoll
  alias Systems.StringToRollableParser
  alias Systems.DiceRolls.StringifyDiceRollSystem

  query do
    field :roll, non_null(list_of(non_null(:string))) do
      arg :tokens, non_null(:string), description: "eg 1d6 + 2... separated by: , " 
      
      resolve fn _, %{tokens: tokens}, _ ->
        with {:ok, parsed} <- StringToRollableParser.parse_all(tokens),
             rolled = MakeRoll.roll(parsed),
             {:ok, formatted_results} <- StringifyDiceRollSystem.format_for_api(rolled) do
          {:ok, formatted_results}
        else
          {:error, reason} -> {:error, reason}
          _ -> {:error, "An unexpected error occurred while processing the roll."}
        end
      end
    end
  end
end
