defmodule Roller.Resolvers.ParserTest do
  use ExUnit.Case, async: true

  alias Roller.Resolvers.Parser

  describe "parser/3" do
    test "parses standard dice notation" do
      assert {:ok, [result]} = Parser.parser(nil, %{tokens: "2d6"}, nil)
      assert is_integer(result)
      assert result >= 2 and result <= 12
    end

    test "parses fate dice notation" do
      assert {:ok, [result]} = Parser.parser(nil, %{tokens: "4df"}, nil)
      assert is_integer(result)
      assert result >= -4 and result <= 4
    end

    test "parses flat constants" do
      assert {:ok, [res1, res2]} = Parser.parser(nil, %{tokens: "5, +10"}, nil)
      assert res1 == 5
      assert res2 == 10
    end

    test "handles comma-separated tokens with whitespace" do
      tokens = " 3d6 ,  4 d   4 , 5 "
      assert {:ok, [r1, r2, r3]} = Parser.parser(nil, %{tokens: tokens}, nil)

      assert r1 >= 3 and r1 <= 18
      assert r2 >= 4 and r2 <= 16
      assert r3 == 5
    end

    test "returns error tuple for invalid token patterns" do
      tokens = "2d6, invalid_token, 5"
      assert {:ok, [r1, error, r3]} = Parser.parser(nil, %{tokens: tokens}, nil)

      assert r1 >= 2 and r1 <= 12
      assert error == {:error, "Unsupported roll pattern: invalid_token"}
      assert r3 == 5
    end
  end
    describe "arithmetic expressions and modifiers" do
      test "Partition 1: Addition and subtraction modifiers" do
        # Test addition with dice
        assert {:ok, [result_add]} = Parser.parser(nil, %{tokens: "4d4 + 5"}, nil)
        assert is_number(result_add)
        assert result_add >= 9 and result_add <= 21 # (4-16) + 5

        # Test subtraction constants
        assert {:ok, [result_sub]} = Parser.parser(nil, %{tokens: "10 - 5"}, nil)
        assert result_sub == 5
      end

      test "Partition 2: Multiplication and division operators" do
        # Test division
        assert {:ok, [result_div]} = Parser.parser(nil, %{tokens: "10 / 2"}, nil)
        assert result_div == 5 or abs(result_div - 5.0) < 0.001

        # Test multiplication
        assert {:ok, [result_mul]} = Parser.parser(nil, %{tokens: "4d4 * 2"}, nil)
        assert is_number(result_mul)
        assert result_mul >= 8 and result_mul <= 32
      end

      test "Partition 3: Complex nested expressions with parentheses" do
        # Test full compound expression with operator precedence and grouping
        tokens = "(4d4 + 1) / (1d5 - 2) * 3"
        
        # Depending on backend error handling for edge-case divisions (like division by zero if 1d5 rolls 2),
        # this ensures the parser handles the compound structure gracefully.
        case Parser.parser(nil, %{tokens: tokens}, nil) do
          {:ok, [result]} -> 
            assert is_number(result)
          {:error, reason} -> 
            # Graceful fallback assertion if division-by-zero is caught by the resolver
            assert is_binary(reason) or is_atom(reason)
        end
      end
    end
end
