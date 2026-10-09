defmodule PhoenixFrontendWeb.HelloHTML do
  use PhoenixFrontendWeb, :html


  # def index(assigns) do
  #   ~H"""
  #     Hello!
  #   """
  # end
 end

defmodule PhoenixFrontendWeb.HelloHTML do
  use PhoenixFrontendWeb, :html

  embed_templates "hello_html/*"
end
