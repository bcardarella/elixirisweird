defmodule Elixirisweird.Repo do
  use Ecto.Repo,
    otp_app: :elixirisweird,
    adapter: Ecto.Adapters.Postgres
end
