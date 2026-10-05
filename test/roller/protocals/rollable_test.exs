defmodule Roller.RollableTest do
  use ExUnit.Case, async: true

  alias Roller.Rollable
  alias Roller.Dice
  alias Roller.FateDice
  alias Roller.Constant

  describe "Roller.Dice" do
    test "rolls values within expected min and max boundaries" do
      dice = %Dice{count: 3, sides: 6}

      # Test multiple iterations to verify range compliance (3 to 18)
      for _ <- 1..100 do
        result = Rollable.roll(dice)
        assert result >= 3 and result <= 18
      end
    end

    test "handles single die roll" do
      dice = %Dice{count: 1, sides: 20}
      result = Rollable.roll(dice)

      assert result >= 1 and result <= 20
    end
  end

  describe "Roller.FateDice" do
    test "rolls values within -count to +count range" do
      fate = %FateDice{count: 4}

      # Range for 4 Fate dice is -4 to +4
      for _ <- 1..100 do
        result = Rollable.roll(fate)
        assert result >= -4 and result <= 4
      end
    end
  end

  describe "Roller.Constant" do
    test "returns exact integer value" do
      assert Rollable.roll(%Constant{value: 5}) == 5
      assert Rollable.roll(%Constant{value: -3}) == -3
      assert Rollable.roll(%Constant{value: 0}) == 0
    end
  end
end
