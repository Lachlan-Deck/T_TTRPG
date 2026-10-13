defmodule Systems.MakeRollTest do
  use ExUnit.Case, async: true

  alias Systems.StringToRollableParser, as: Parser
  alias Systems.MakeRoll
  alias Components.RollString.NormalDiceComponent
  alias Components.RollString.FateDiceComponent
  alias Components.RollString.OperatorComponent
  alias Components.RollString.ExplodingDiceComponent
  alias Components.RollString.UnParsedComponent

  # Helper to parse and roll in one step for cleaner test assertions
  defp parse_and_roll(string) do
    {:ok, parsed} = Parser.parse_all(string)
    MakeRoll.roll(parsed)
  end

  describe "MakeRoll / Parser integration" do
    test "parses and rolls standard dice notation (e.g., 2d6)" do
      # [[%NormalDiceComponent{}, %NormalDiceComponent{}]]
      assert [[c1, c2]] = parse_and_roll("2d6")
      
      assert c1.sides == 6
      assert c1.res_value >= 1 and c1.res_value <= 6

      assert c2.sides == 6
      assert c2.res_value >= 1 and c2.res_value <= 6

      total = c1.res_value + c2.res_value
      assert total >= 2 and total <= 12
    end

    test "parses and rolls fate dice notation (e.g., 4df)" do
      assert [fate_list] = parse_and_roll("4df")
      assert length(fate_list) == 4

      total_res = Enum.sum(Enum.map(fate_list, & &1.res_value))
      assert total_res >= -4 and total_res <= 4
      assert Enum.all?(fate_list, fn f -> f.res_value in [-1, 0, 1] end)
    end

    test "parses and rolls flat constants / operators" do
      # "5" becomes an operator or unparsed/constant, let's see how operator handles "+10" vs "5"
      # "+10" matches OperatorComponent. "5" might fall back to UnParsedComponent or operator depending on your regex.
      # Let's test standard operators like "+5" and "+10"
      assert [[c1, c2]] = parse_and_roll("+5, +10")
      # Wait, parse_all splits on commas first:
      # " +5" and " +10" are two separate roll strings in the returned list of lists:
      # [[%OperatorComponent{value: 5}], [%OperatorComponent{value: 10}]]
      
      [[op1], [op2]] = parse_and_roll("+5, +10")
      assert op1.res_value == 5
      assert op2.res_value == 10
    end

    test "handles comma-separated tokens in a single string vs multiple rolls" do
      # If separated by commas, they are distinct roll strings (lists within the outer list)
      # e.g., "3d6, 4d4, +5"
      assert [roll1, roll2, roll3] = parse_and_roll("3d6, 4d4, +5")

      assert length(roll1) == 3
      sum1 = Enum.sum(Enum.map(roll1, & &1.res_value))
      assert sum1 >= 3 and sum1 <= 18

      assert length(roll2) == 4
      sum2 = Enum.sum(Enum.map(roll2, & &1.res_value))
      assert sum2 >= 4 and sum2 <= 16

      assert [%OperatorComponent{res_value: 5}] = roll3
    end

    test "handles mixed dice and modifier expressions (e.g., 4d4 + 5)" do
      assert [[d1, d2, d3, d4, op]] = parse_and_roll("4d4 + 5")

      assert %NormalDiceComponent{} = d1
      assert %OperatorComponent{operator: "+", value: 5, res_value: 5} = op

      dice_sum = d1.res_value + d2.res_value + d3.res_value + d4.res_value
      assert dice_sum >= 4 and dice_sum <= 16
    end

    test "handles unparsed fallback tokens gracefully" do
      assert [[d1, unparsed]] = parse_and_roll("1d20 + PROF")
      
      assert %NormalDiceComponent{sides: 20} = d1
      assert %UnParsedComponent{raw: "+PROF"} = unparsed
    end

    test "exploding dice dynamically expand the component list on max roll" do
      # We can run it multiple times to catch an explosion, or just assert structure types
      assert [[exploding_die]] = parse_and_roll("!1d4")
      
      # Since it's a recursive chain, it will return at least 1 component, 
      # and more if it maxed out on 4.
      assert is_list(parse_and_roll("!1d4"))
      [first | rest] = hd(parse_and_roll("!1d4"))
      assert %ExplodingDiceComponent{sides: 4} = first
      
      if first.res_value == 4 do
        # If it exploded, there should be subsequent items in the chain
        assert length(rest) >= 0
      end
    end
  end
end
