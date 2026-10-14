defmodule Components.RollString.FateDiceComponent do
  use Components.RollString.Component

  @moduledoc """
  this is a component for fate dice, data of this type should contain only the
  state of a fate dice token, expressed with the syntax *df eg. "4df, 21df,
  8df... etc.". res value is the result of the processing of the token. 
  """
  @type t :: %__MODULE__{
          res_value: integer()
        }

  defstruct [:res_value]
  @impl true
  @spec from_string(String.t()) :: {:ok, t() | list(t())} | {:error, String.t()}
  def from_string(string) when is_binary(string) do
    cleaned = string |> String.trim() |> String.downcase()

    case Regex.run(~r/^(\d*)df$/, cleaned) do
      [_, count_str] ->
        count = if count_str == "", do: 1, else: String.to_integer(count_str)
        components = List.duplicate(%__MODULE__{res_value: 0}, count)

        if count == 1, do: {:ok, hd(components)}, else: {:ok, components}

      nil ->
        {:error, "Invalid fate dice format. Expected syntax like '*df'. Got: #{string}"}
    end
  end
end
