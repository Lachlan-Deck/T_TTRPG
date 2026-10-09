defmodule PhoenixFrontendWeb.PageController do
  use PhoenixFrontendWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
