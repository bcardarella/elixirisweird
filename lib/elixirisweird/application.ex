defmodule Elixirisweird.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElixirisweirdWeb.Telemetry,
      Elixirisweird.Repo,
      {DNSCluster, query: Application.get_env(:elixirisweird, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Elixirisweird.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Elixirisweird.Finch},
      # Start a worker by calling: Elixirisweird.Worker.start_link(arg)
      # {Elixirisweird.Worker, arg},
      # Start to serve requests, typically the last entry
      ElixirisweirdWeb.Endpoint,
      {Beacon, [sites: [Application.fetch_env!(:beacon, :elixirisweird)]]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Elixirisweird.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirisweirdWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
