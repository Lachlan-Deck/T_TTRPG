defmodule Components.RollString.Component do
  @type t :: struct()

  @callback from_string(String.t()) :: {:ok, t() | list(t())} | {:error, String.t()}

  defmacro __using__(_opts) do
    quote do
      @behaviour Components.RollString.Component
    end
  end
end
