defmodule PheonixFrontendWeb.PageController do
  use PheonixFrontendWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
