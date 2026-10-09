# lib/Phoenix_frontend_web/controllers/hello_controller.ex
defmodule PhoenixFrontendWeb.HelloController do
  use PhoenixFrontendWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
  def show(conn, %{"messenger" => messenger}) do
  render(conn, :show, messenger: messenger)
end
end
