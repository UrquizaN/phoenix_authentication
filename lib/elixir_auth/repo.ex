defmodule ElixirAuth.Repo do
  use Ecto.Repo,
    otp_app: :elixir_auth,
    adapter: Ecto.Adapters.Postgres
end
