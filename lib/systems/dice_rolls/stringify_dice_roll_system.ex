defmodule Systems.DiceRolls.StringifyDiceRollSystem do
  @doc """
  this system takes rolled RollString components (ones that have a value of
  not 0) and returns a stringified version of them so that the user can see
  understand what they rolled on the dice.

  it returns both a fully exploded string of all rolls, each roll token
  contained in brackets (), and it returns a total of the roll
  """
  alias Components.RollString.ExplodingDiceComponent
  alias Components.RollString.FateDiceComponent
  alias Components.RollString.NormalDiceComponent
  alias Components.RollString.OperatorComponent
  alias Components.RollString.UnParsedComponent

  # ███████╗███████╗███████╗███████╗███████╗███████╗███████╗
  # ╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝

  @spec stringify(list(term()) | list(list(term()))) ::
          {:ok, String.t(), number()} | {:ok, list({String.t(), number()})}
  def stringify(rolls) when is_list(rolls) do
    # Handle both a single list of components and a list of lists (from parse_all)
    if Enum.all?(rolls, &is_list/1) do
      results = Enum.map(rolls, &stringify_single/1)
      {:ok, results}
    else
      stringify_single(rolls)
    end
  end

  # ███████╗███████╗███████╗███████╗███████╗███████╗███████╗
  # ╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝

  @spec stringify_single(list(term())) :: {:ok, String.t(), number()}
  defp stringify_single(components) do
    exploded_string =
      components
      |> Enum.map(&format_component/1)
      |> Enum.join(" ")

    total = calculate_total(components)

    {:ok, exploded_string, total}
  end

  # ███████╗███████╗███████╗███████╗███████╗███████╗███████╗
  # ╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝

  @doc """
  Convenience function that converts rolled components directly into 
  ready-to-display strings for API responses.
  """
  @spec format_for_api(list(term()) | list(list(term()))) ::
          {:ok, list(String.t())} | {:error, term()}
  def format_for_api(rolls) do
    case stringify(rolls) do
      {:ok, results} when is_list(results) ->
        formatted = Enum.map(results, fn {:ok, str, total} -> "#{str} (Total: #{total})" end)
        {:ok, formatted}

      {:ok, str, total} ->
        {:ok, ["#{str} (Total: #{total})"]}

      {:error, _} = error ->
        error
    end
  end

  # ███████╗███████╗███████╗███████╗███████╗███████╗███████╗
  # ╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝

  # Calculate the final numeric total taking operators into account
  defp calculate_total(components) do
    {total, _} =
      Enum.reduce(components, {0, "+"}, fn component, {acc, op} ->
        case component do
          %NormalDiceComponent{res_value: val} ->
            {apply_op(acc, op, val), "+"}

          %ExplodingDiceComponent{res_value: val} ->
            {apply_op(acc, op, val), "+"}

          %FateDiceComponent{res_value: val} ->
            {apply_op(acc, op, val), "+"}

          %OperatorComponent{operator: next_op, value: val} ->
            {apply_op(acc, next_op, val), "+"}

          %UnParsedComponent{} ->
            # Unparsed tokens don't contribute to the numeric total
            {acc, op}
        end
      end)

    total
  end

  # ██╗  ██╗███████╗██╗     ██████╗ ███████╗██████╗ ███████╗
  # ██║  ██║██╔════╝██║     ██╔══██╗██╔════╝██╔══██╗██╔════╝
  # ███████║█████╗  ██║     ██████╔╝█████╗  ██████╔╝███████╗
  # ██╔══██║██╔══╝  ██║     ██╔═══╝ ██╔══╝  ██╔══██╗╚════██║
  # ██║  ██║███████╗███████╗██║     ███████╗██║  ██║███████║
  # ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝

  # Format each component into a bracketed token string
  defp format_component(%NormalDiceComponent{res_value: val}), do: "(#{val})"
  defp format_component(%ExplodingDiceComponent{res_value: val}), do: "(#{val})"
  defp format_component(%FateDiceComponent{res_value: val}), do: "(#{val})"
  defp format_component(%OperatorComponent{operator: op, value: val}), do: "(#{op}#{val})"
  defp format_component(%UnParsedComponent{raw: raw}), do: "(#{raw})"

  # Helper math operations
  defp apply_op(acc, "+", val), do: acc + val
  defp apply_op(acc, "-", val), do: acc - val
  defp apply_op(acc, "*", val), do: acc * val
  defp apply_op(acc, "/", val) when val != 0, do: acc / val
  defp apply_op(acc, _, _), do: acc

  # ███████╗███████╗███████╗███████╗███████╗███████╗███████╗
  # ╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝
end
