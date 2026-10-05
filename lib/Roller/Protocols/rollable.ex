defprotocol Roller.Rollable do
  @doc "defines a syntax for rollable strings. (if a sequence of strings isn't
  valid in this protocal, then it should be ignored and returned as is by the
  roller, but that behaviour is out of scope of this interface.)"
  @spec roll(t()) :: integer()
  def roll(data)
end

defmodule Roller.Dice do
  @doc "for normal dice rolls like 3d4 or 1d20 etc"
  @enforce_keys [:count, :sides]
  defstruct [:count, :sides]

  defimpl Roller.Rollable do
    def roll(%Roller.Dice{count: count, sides: sides}) do
      Enum.sum(for _ <- 1..count, do: Enum.random(1..sides))
    end
  end
end

defmodule Roller.Constant do
  @doc "for constant values, eg +5, or -1"
  @enforce_keys [:value]
  defstruct [:value]

  defimpl Roller.Rollable do
    def roll(%Roller.Constant{value: value}), do: value
  end
end



