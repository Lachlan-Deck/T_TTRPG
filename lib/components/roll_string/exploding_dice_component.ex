defmodule Components.RollString.ExplodingDiceComponent do
  use Components.RollString.Component

  @moduledoc """
  exploding dice are expressed with the !*d* syntax, eg: "!4d4". if a roll
  is exploding, then if the max of sides is rolled the dice is re-rolled for
  until the roll is not the max result, and the totals are added together
  """
  @type t :: %__MODULE__{
          sides: integer(),
          res_value: integer()
        }

  defstruct [
    :sides,
    :res_value
  ]

  @impl true
  @spec from_string(String.t()) :: {:ok, t() | list(t())} | {:error, String.t()}
  def from_string(string) when is_binary(string) do
    cleaned = string |> String.trim() |> String.downcase()

    case Regex.run(~r/^!(\d*)d(\d+)$/, cleaned) do
      [_, count_str, sides_str] ->
        count = if count_str == "", do: 1, else: String.to_integer(count_str)
        sides = String.to_integer(sides_str)

        # Create a list of identical unrolled exploding dice components based on count
        components = List.duplicate(%__MODULE__{sides: sides, res_value: 0}, count)

        # Return a single struct if count is 1, otherwise return the list
        if count == 1, do: {:ok, hd(components)}, else: {:ok, components}

      nil ->
        {:error,
         "Invalid exploding dice format. Expected syntax like '!4d4' or '!d6'. Got: #{string}"}
    end
  end
end
