defmodule PheonixFrontendWeb.HelloHTML do
  use PheonixFrontendWeb, :html


  # def index(assigns) do
  #   ~H"""
  #     Hello!
  #   """
  # end
 end

defmodule PheonixFrontendWeb.HelloHTML do
  use PheonixFrontendWeb, :html

  embed_templates "hello_html/*"
end
