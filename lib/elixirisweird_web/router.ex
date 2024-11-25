defmodule ElixirisweirdWeb.Router do
  use ElixirisweirdWeb, :router

  use Beacon.Router
  use Beacon.LiveAdmin.Router

  pipeline :beacon_admin do
    plug Beacon.LiveAdmin.Plug
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ElixirisweirdWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through [:browser, :beacon_admin]
    beacon_live_admin "/admin"
    beacon_site "/", site: :elixirisweird, root_layout: {ElixirisweirdWeb.Layouts, :"2025"}
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirisweirdWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:elixirisweird, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ElixirisweirdWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
