defmodule Systems.RollResolver do
  @doc """
  Resolves the :roll query by broadcasting an event to the PubSub event bus 
  and waiting asynchronously for the Systems.DiceRollHandler to reply.
  """
  def roll(_parent, %{tokens: tokens}, _resolution) do
    # 1. Broadcast the event to PubSub, passing self() as client_pid
    Phoenix.PubSub.broadcast(
      TTtrpg.PubSub, 
      "events:roll_requested", 
      {:roll_requested, self(), tokens}
    )

    # 2. Wait for the GenServer to respond back to our process mailbox
    receive do
      {:roll_result, {:ok, formatted}} -> 
        {:ok, formatted}

      {:roll_result, {:error, reason}} -> 
        {:error, reason}
    after 5000 ->
      {:error, "Timeout waiting for roll result"}
    end
  end
end
