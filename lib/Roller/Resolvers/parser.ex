# lib/Roller/Resolvers/parser.ex
defmodule Roller.Resolvers.Parser do
  alias Roller.Rollable
  alias Roller.Constant
  alias Roller.Dice
  @doc """
  this is where roll strings are taken and parsed, then the roll interface is
  used to return a roll result
  """
  @type roll_result :: integer()
  @spec parser(
          term(),
          %{tokens: String.t()},
          term()
        ) ::
          {:ok, list(roll_result())} | {:error, String.t()}

  def parser(_parent, %{tokens: tokens}, _resolution) when is_binary(tokens) do
    results =
      tokens
      |> String.split(",")
      |> Enum.map(&String.replace(&1, " ", ""))
      |> Enum.map(&evaluate_token/1)

    {:ok, results}
  end

  defp evaluate_token(token_str) do
    case parse_rollable(token_str) do
      {:ok, rollable} ->
        Rollable.roll(rollable)

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp parse_rollable(str) do
    cond do
      # Standard dice match: "3d6"
      match = Regex.run(~r/^(\d+)d(\d+)$/i, str) ->
        [_, count, sides] = match
        {:ok, %Dice{count: String.to_integer(count), sides: String.to_integer(sides)}}

      # Flat constant match: "5" or "+5"
      match = Regex.run(~r/^\+?(\d+)$/, str) ->
        [_, val] = match
        {:ok, %Constant{value: String.to_integer(val)}}

      true ->
        {:error, "Unsupported roll pattern: #{str}"}
    end
  end
end
