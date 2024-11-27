defmodule ElixirIsWeird.Plugs.SiteBasicAuth do
  @moduledoc false
  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    [username, password] = Application.get_env(:elixirisweird, :basic_auth)
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end
end
