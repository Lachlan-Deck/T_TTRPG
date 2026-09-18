# lib/Roller/Schemas/schema.ex
defmodule Roller.Schema do
  use Absinthe.Schema
  
  alias Roller.Resolvers

  query do
    field :roll, non_null(list_of(non_null(:string))) do
      arg :tokens, non_null(:string), description: "eg 1d6 + 2... separated by: , " 
    resolve &Resolvers.Parser.parser/3
    end
  end
end
