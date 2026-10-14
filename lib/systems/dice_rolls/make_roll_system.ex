defmodule Systems.MakeRoll do
  @doc """
    a system for computing the random chance results of rollable_components
    with empty values, and it returns a list identical in order but with the
    values of the rollale components filled
  """
  alias Components.RollString.NormalDiceComponent
  alias Components.RollString.ExplodingDiceComponent
  alias Components.RollString.FateDiceComponent
  alias Components.RollString.OperatorComponent
  alias Components.RollString.UnParsedComponent

  @spec roll(list(term()) | list(list(term()))) :: list(term()) | list(list(term()))
  def roll(rolls) when is_list(rolls) do
    # Handle both a single list of components and a list of lists (from parse_all)
    if Enum.all?(rolls, &is_list/1) do
      Enum.map(rolls, &roll_single_list/1)
    else
      roll_single_list(rolls)
    end
  end

  @spec roll_single_list(list(term())) :: list(term())
  defp roll_single_list(components) do
    Enum.map(components, fn component ->
      compute_component(component)
    end)
  end

  # 1. Normal Dice: rolls 1 to sides using :rand.uniform
  defp compute_component(%NormalDiceComponent{sides: sides} = comp) do
    rolled_value = :rand.uniform(sides)
    %NormalDiceComponent{comp | res_value: rolled_value}
  end

# 2. Exploding Dice: rolls, and if max sides is hit, recursively prepends 
  # another exploding component to the list of re-rolls.
  defp compute_component(%ExplodingDiceComponent{sides: sides} = comp) do
    roll_exploding_chain(sides, comp)
  end
  
  # 3. Fate Dice: rolls a random state of -1, 0, or +1
  defp compute_component(%FateDiceComponent{} = comp) do
    rolled_value = Enum.random([-1, 0, 1])
    %FateDiceComponent{comp | res_value: rolled_value}
  end

  # 4. Operator Component: Static math, sets res_value to its value
  defp compute_component(%OperatorComponent{} = comp) do
    %OperatorComponent{comp | res_value: comp.value}
  end

  # 5. UnParsed Component: Left as-is
  defp compute_component(%UnParsedComponent{} = comp) do
    comp
  end

  # Helper for exploding dice recursion
  defp roll_exploding_chain(sides, comp) do
    val = :rand.uniform(sides)
    current_component = %ExplodingDiceComponent{comp | res_value: val}

    if val == sides do
      # Hit max! Keep this component and append the next explosion in the chain
      [current_component | roll_exploding_chain(sides, comp)]
    else
      # Normal roll, stop exploding
      [current_component]
    end
  end
end
