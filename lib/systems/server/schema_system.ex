# lib/systems/server/schema_system.ex
defmodule Systems.Schema do
  use Absinthe.Schema
  alias Systems.RollResolver

  query do
    field :roll, non_null(list_of(non_null(:string))) do
      arg(:tokens, non_null(:string), description: "eg 1d6 + 2... separated by: , ")
      resolve(&RollResolver.roll/3)
    end
  end
end
