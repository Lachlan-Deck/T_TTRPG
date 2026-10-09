# lib/Roller/Resolvers/parser.ex
defmodule Roller.Resolvers.Parser do
  alias Roller.Rollable
  alias Roller.Constant
  alias Roller.Dice
  alias Roller.FateDice
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
    try do
      if Regex.match?(~r/[\+\-\*\/\(\)]/, token_str) do
        case evaluate_expression(token_str) do
          {:ok, val} -> val
          {:error, reason} -> {:error, reason}
        end
      else
        case parse_rollable(token_str) do
          {:ok, rollable} ->
            Rollable.roll(rollable)

          {:error, reason} ->
            {:error, reason}
        end
      end
    rescue
      _e ->
        {:error, "Unsupported roll pattern: #{token_str}"}
    end
  end
defp evaluate_expression(expr_str) do
    resolved_expr =
      expr_str
      |> then(fn str ->
        Regex.replace(~r/(\d+)df/i, str, fn _, count ->
          fate = %FateDice{count: String.to_integer(count)}
          Integer.to_string(Rollable.roll(fate))
        end)
      end)
      |> then(fn str ->
        Regex.replace(~r/(\d+)d(\d+)/i, str, fn _, count, sides ->
          dice = %Dice{count: String.to_integer(count), sides: String.to_integer(sides)}
          Integer.to_string(Rollable.roll(dice))
        end)
      end)

    if Regex.match?(~r/^[0-9\.\+\-\*\/\(\)\s]+$/, resolved_expr) do
      try do
        {result, _} = Code.eval_string(resolved_expr)
        {:ok, result}
      rescue
        _ -> {:error, "Unsupported roll pattern: #{expr_str}"}
      end
    else
      {:error, "Unsupported roll pattern: #{expr_str}"}
    end
  end

  defp parse_rollable(str) do
    cond do
      match = Regex.run(~r/^(\d+)df$/i, str) ->
        [_, count] = match
        {:ok, %FateDice{count: String.to_integer(count)}}

      # Standard dice match: "3d6"
      match = Regex.run(~r/^(\d+)d(\d+)$/i, str) ->
        [_, count, sides] = match
        {:ok, %Dice{count: String.to_integer(count), sides: String.to_integer(sides)}}

      # Flat constant match: "5" or "+5"
      match = Regex.run(~r/^\+?(-?\d+)$/, str) ->
        [_, val] = match
        {:ok, %Constant{value: String.to_integer(val)}}

      true ->
        {:error, "Unsupported roll pattern: #{str}"}
    end
  end
end
