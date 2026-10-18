defmodule Systems.DiceRollHandler do
  use GenServer

  alias Systems.StringToRollableParser
  alias Systems.MakeRoll
  alias Systems.StringifyDiceRollSystem

  def start_link(opts), do: GenServer.start_link(__MODULE__, opts, name: __MODULE__)

  @impl true
  def init(_opts) do
    Phoenix.PubSub.subscribe(TTtrpg.PubSub, "events:roll_requested")
    {:ok, %{}}
  end

  @impl true
  def handle_info({:roll_requested, client_pid, tokens}, state) do
    result =
      with {:ok, parsed} <- StringToRollableParser.parse_all(tokens),
           rolled = MakeRoll.roll(parsed),
           {:ok, formatted} <- StringifyDiceRollSystem.format_for_api(rolled) do
        {:ok, formatted}
      else
        {:error, reason} -> {:error, reason}
      end

    send(client_pid, {:roll_result, result})
    {:noreply, state}
  end
end
