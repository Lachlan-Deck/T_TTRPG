defmodule PhoenixFrontendWeb.Components.RollHistoryComponent do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div class="flex-1 overflow-y-auto p-4 md:p-6 space-y-4 max-w-2xl w-full mx-auto">
      <%= if Enum.empty?(@history) do %>
        <div class="h-full flex items-center justify-center text-[#928374] text-sm">
          No rolls yet. Type your roll below and press enter or click Roll!
        </div>
      <% end %>

      <%= for item <- @history do %>
        <div class="flex flex-col space-y-2 bg-[#32302f] border border-[#504945] p-4 rounded-xl shadow-md">
          <span class="text-xs font-medium text-[#a89984]">
            Roll: <span class="font-mono text-[#ebdbb2]"><%= item.input %></span>
          </span>

          <%= if item.result do %>
            <div class="flex flex-wrap gap-2">
              <%= for res <- item.result do %>
                <span class="bg-[#83a598]/20 border border-[#83a598]/40 text-[#83a598] px-3 py-1 rounded-lg font-mono text-sm">
                  <%= res %>
                </span>
              <% end %>
            </div>
          <% else %>
            <p class="text-[#fb4934] text-sm font-medium">
              <%= item.error %>
            </p>
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end
end
