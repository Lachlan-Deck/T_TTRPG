defmodule Systems.StringToRollableParser do

# ████████╗██╗   ██╗██████╗ ███████╗███████╗
# ╚══██╔══╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔════╝
#    ██║    ╚████╔╝ ██████╔╝█████╗  ███████╗
#    ██║     ╚██╔╝  ██╔═══╝ ██╔══╝  ╚════██║
#    ██║      ██║   ██║     ███████╗███████║
#    ╚═╝      ╚═╝   ╚═╝     ╚══════╝╚══════╝
#
  alias Components.RollString.FateDiceComponent
  alias Components.RollString.UnParsedComponent
  alias Components.RollString.ExplodingDiceComponent
  alias Components.RollString.NormalDiceComponent
  alias Components.RollString.OperatorComponent
  
  @components [
    ExplodingDiceComponent,
    FateDiceComponent,
    NormalDiceComponent,
    OperatorComponent
  ]
  
  @type rollable_component ::
    ExplodingDiceComponent.t()
    | FateDiceComponent.t()
    | NormalDiceComponent.t()
    | OperatorComponent.t()
    | UnParsedComponent.t()

  @type rollable_tuple :: list(list(rollable_component()))
  
# ██╗  ██╗███████╗██╗     ██████╗ ███████╗██████╗ ███████╗
# ██║  ██║██╔════╝██║     ██╔══██╗██╔════╝██╔══██╗██╔════╝
# ███████║█████╗  ██║     ██████╔╝█████╗  ██████╔╝███████╗
# ██╔══██║██╔══╝  ██║     ██╔═══╝ ██╔══╝  ██╔══██╗╚════██║
# ██║  ██║███████╗███████╗██║     ███████╗██║  ██║███████║
# ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝

# ███████╗███████╗███████╗███████╗███████╗███████╗███████╗
# ╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝

  @spec parse_all(String.t()) :: {:ok, list(list(term()))} | {:error, String.t()}
  def parse_all(string) when is_binary(string) do
    roll_strings = String.split(string, ",")

    parsed_rolls =
      Enum.map(roll_strings, fn roll_str ->
        parse_roll_string(roll_str)
      end)

    {:ok, parsed_rolls}
  end
                                                        
# ███████╗███████╗███████╗███████╗███████╗███████╗███████╗
# ╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝

  @spec parse_one(String.t()) :: {:ok, term() | list(term())}
  def parse_one(token) when is_binary(token) do
    trimmed = String.trim(token)

    # Try each component's from_string/1 function in sequence
    matched_component =
      Enum.find_value(@components, fn component_module ->
        case component_module.from_string(trimmed) do
          {:ok, result} -> {:ok, result}
          {:error, _} -> nil
        end
      end)

    # Fallback to UnParsedComponent if no structured component matched
    case matched_component do
      {:ok, result} ->
        {:ok, result}

      nil ->
        UnParsedComponent.from_string(trimmed)
    end
  end
  
# ███████╗███████╗███████╗███████╗███████╗███████╗███████╗
# ╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝

@spec parse_roll_string(String.t()) :: list(term())
  def parse_roll_string(roll_str) do
    cleaned = String.trim(roll_str)

    if cleaned == "" do
      []
    else
      normalized = Regex.replace(~r/([+\-\*\/])\s+([a-zA-Z0-9]+)/, cleaned, "\\1\\2")
      tokens = String.split(normalized, ~r/\s+/)

      Enum.flat_map(tokens, fn token ->
        case parse_one(token) do
          {:ok, list} when is_list(list) -> list
          {:ok, single} -> [single]
        end
      end)
    end
  end

# ███████╗███████╗███████╗███████╗███████╗███████╗███████╗
# ╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝
end
