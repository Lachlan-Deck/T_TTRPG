defmodule PhoenixFrontendWeb.InputRollComponent do
  use PhoenixFrontendWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="border p-4 rounded-lg">
      <form phx-change="update_roll_string">
        <input type="text"
          id="roll_string"
          name="roll_string"
          placeholder ="make a roll. eg. 3d4 + 5"
          value={@roll_string}/>
      </form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, roll_string: "")}
  end

  def handle_event("update_roll_string", %{"roll_string" => roll_string}, socket) do
    {:noreply, assign(socket, roll_string: roll_string)}
    
  end
end
