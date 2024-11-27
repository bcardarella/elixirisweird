defmodule ElixirIsWeirdWeb.Router do
  use ElixirIsWeirdWeb, :router

  use Beacon.Router
  use Beacon.LiveAdmin.Router

  pipeline :beacon_admin do
    plug Beacon.LiveAdmin.Plug
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ElixirIsWeirdWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/admin" do
    pipe_through [:browser, :beacon_admin, ElixirIsWeird.Plugs.SiteBasicAuth]
    beacon_live_admin "/"
  end

  scope "/" do
    pipe_through [:browser, :beacon_admin]
    beacon_site "/", site: :elixirisweird, root_layout: {ElixirIsWeirdWeb.Layouts, :"2025"}
  end

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

      live_dashboard "/dashboard", metrics: ElixirIsWeirdWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
