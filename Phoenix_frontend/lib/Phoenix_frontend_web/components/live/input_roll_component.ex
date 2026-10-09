# /lib/Phoenix_frontend_web/components/live/input_roll_component.ex
defmodule PhoenixFrontendWeb.Components.InputRollComponent do
  use Phoenix.LiveComponent
  require Logger

  def render(assigns) do
    ~H"""
    <div class="border-t border-[#504945] bg-[#32302f]/80 backdrop-blur p-4">
      <form
      phx-submit="submit_roll"
      phx-target={@myself}
      class="max-w-2xl mx-auto flex items-center gap-3">

        <textarea
        name="roll_string"
        rows={1}
        class="flex-1 bg-[#1d2021] border border-[#504945] rounded-xl px-4 py-3 text-[#ebdbb2] placeholder-[#928374] focus:outline-none focus:border-[#d3869b] focus:ring-1 focus:ring-[#d3869b] resize-none text-sm"
        placeholder ="make a roll. eg. 3d4 + 5"
        ></textarea>
        
        <button
        type="submit"
        class="bg-[#d3869b] hover:bg-[#b16286] text-[#1d2021] font-bold px-6 py-3 rounded-xl transition-all shadow-lg text-sm cursor-pointer"
        >
          Roll
        </button>
      </form>
    </div>
    """
  end
  
  def handle_event("submit_roll", %{"roll_string" => roll_string}, socket) do
    Logger.info("[InputRollComponent] Received submit_roll with: #{inspect(roll_string)}")
    if String.trim(roll_string) != "" do            
      send(self(), {:make_roll, roll_string})
    end
    {:noreply, socket}
  end
end
