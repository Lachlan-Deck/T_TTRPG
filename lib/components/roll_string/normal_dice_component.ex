defmodule Components.RollString.NormalDiceComponent do
  use Components.RollString.Component
  @moduledoc """
  this is the normal dice roll, expressed with the syntax *d*, eg: "1d20"
  """
  @type t :: %__MODULE__{
          sides: integer(),
          res_value: integer()
        }

  defstruct [:sides, :res_value]
  @impl true
  @spec from_string(String.t()) :: {:ok, t() | list(t())} | {:error, String.t()}
  def from_string(string) when is_binary(string) do
    cleaned = string |> String.trim() |> String.downcase()

    case Regex.run(~r/^(\d*)d(\d+)$/, cleaned) do
      [_, count_str, sides_str] ->
        count = if count_str == "", do: 1, else: String.to_integer(count_str)
        sides = String.to_integer(sides_str)
        components = List.duplicate(%__MODULE__{sides: sides, res_value: 0}, count)

        if count == 1, do: {:ok, hd(components)}, else: {:ok, components}

      nil ->
        {:error, "Invalid normal dice format, expected like:'1d20' got:  #{string}"}
    end
  end
end
