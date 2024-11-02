defmodule ElixirAuthWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :elixir_auth,
    module: ElixirAuthWeb.Auth.Guardian,
    error_handler: ElixirAuthWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
