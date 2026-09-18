defmodule TTtrpg do
  @moduledoc """
  Documentation for `TTtrpg`.
  """

  @doc """
  this is the application start function, start with mix run --no-halt
  you should expect localhost:8088/graphiql/ to open an empty page
    """
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Roller.Routers.Router, options: [port: 8088]}
    ]
    opts = [strategy: :one_for_one, name: Roller.Supervisor]
    Logger.info("Starting application...")
    Supervisor.start_link(children, opts)
  end  
end
