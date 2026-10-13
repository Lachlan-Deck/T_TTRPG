defmodule Components.RollString.OperatorComponent do
  use Components.RollString.Component

  @moduledoc """
  this is the expression component, for operations in rolls that have no
  random chance but still effect the result of the dice. eg: "+5" or: "/2"
  """
  @type t :: %__MODULE__{
          operator: String.t(),
          value: integer(),
          res_value: integer()
        }

  defstruct [
    :operator,
    :value,
    :res_value
  ]
  @impl true
  @spec from_string(String.t()) :: {:ok, t()} | {:error, String.t()}
  def from_string(string) when is_binary(string) do
    cleaned = string |> String.trim()

    case Regex.run(~r/^([+\-\*\/])\s*(\d+)$/, cleaned) do
      [_, op, value_str] ->
        {:ok,
         %__MODULE__{
           operator: op,
           value: String.to_integer(value_str),
           res_value: 0
         }}

      nil ->
        {:error, "Invalid expression format. Expected syntax like '+5' or '/2'. Got: #{string}"}
    end
  end
end
