defmodule PhoenixFrontendWeb.RollPageLive do
  use PhoenixFrontendWeb, :live_view

  require Logger
  
  alias PhoenixFrontendWeb.Components.{RollHistoryComponent, InputRollComponent}
  alias PhoenixFrontendWeb.HandleRoll

  def mount(_params, _session, socket) do
    {:ok, assign(socket, history: [])}
  end

  # Listens for the message sent from the InputRollComponent
  def handle_info({:make_roll, roll_string}, socket) do
    Logger.info("[RollPageLive] Processing roll request string: #{inspect(roll_string)}")
    new_item =
      case HandleRoll.roll(roll_string) do
        {:ok, result_list} ->
          %{
            id: System.unique_integer([:positive]),
            input: roll_string,
            result: result_list,
            error: nil
          }

        {:error, reason} ->
          Logger.error("[RollPageLive]: Roll error encountered: #{inspect(reason)}")
          %{
            id: System.unique_integer([:positive]),
            input: roll_string,
            result: nil,
            error: reason
          }
      end

    updated_history = socket.assigns.history ++ [new_item]
    {:noreply, assign(socket, history: updated_history)}
  end

  def render(assigns) do
    ~H"""
    <main class="flex flex-col h-screen bg-[#282828] text-[#ebdbb2] font-sans">
      <!-- Header -->
      <header class="border-b border-[#504945] p-4 text-center bg-[#32302f]/50 backdrop-blur">
        <h1 class="text-xl font-bold tracking-wide text-[#b8bb26] m-0">
          Dice Roller Chat
        </h1>
      </header>

      <!-- Chat History Live Component -->
      <.live_component
        module={PhoenixFrontendWeb.Components.RollHistoryComponent}
        id="chat-history"
        history={@history}
      />

      <!-- Input Roll Live Component -->
      <.live_component
        module={PhoenixFrontendWeb.Components.InputRollComponent}
        id="input-roll"
      />
    </main>
    """
  end
end
