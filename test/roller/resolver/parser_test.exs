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
end
