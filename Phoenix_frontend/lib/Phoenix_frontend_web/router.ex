# lib/Phoenix_frontend_web/router.ex
defmodule PhoenixFrontendWeb.Router do
  use PhoenixFrontendWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhoenixFrontendWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end


  scope "/", PhoenixFrontendWeb do
    pipe_through :browser

    live "/", RollPageLive
    get "/hello", HelloController, :index
    get "/hello/:messenger", HelloController, :show
    live "hello_live_view", HelloLiveView 
  end
  # Other scopes may use custom stacks.
  # scope "/api", PhoenixFrontendWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:Phoenix_frontend, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PhoenixFrontendWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
