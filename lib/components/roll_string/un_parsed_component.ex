defmodule Components.RollString.UnParsedComponent do
  use Components.RollString.Component
  @moduledoc """
  this is for tokens in roll strings that can't be parsed, but should be
  returned for the user flow. things like 1d20 + SPELL should return
  "{1d20 result} + SPELL", this is because the user may have information
  like what their SPELL is that the system does not.
  """
  @type t :: %__MODULE__{
          raw: String.t()
        }

  defstruct [
    :raw
  ]
  @impl true

  @spec from_string(String.t()) :: {:ok, t()}
  def from_string(string) when is_binary(string) do
    {:ok, %__MODULE__{raw: String.trim(string)}}
  end
end
