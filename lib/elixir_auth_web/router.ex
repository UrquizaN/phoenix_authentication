defmodule ElixirAuthWeb.Router do
  use ElixirAuthWeb, :router
  use Plug.ErrorHandler

  def handle_errors(conn, %{reason: %{message: message}}) do
    conn
    |> json(%{errors: %{message: message}})
    |> halt()
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug ElixirAuthWeb.Auth.Pipeline
    plug ElixirAuthWeb.Auth.AccountSession
  end

  scope "/api", ElixirAuthWeb do
    pipe_through :api

    resources "/", DefaultController, only: [:index]
    post "/accounts/create", AccountController, :create
    post "/accounts/sign_in", AccountController, :sign_in
  end

  scope "/api", ElixirAuthWeb do
    pipe_through [:api, :auth]

    get "/accounts/:id", AccountController, :show
    post "/accounts/update", AccountController, :update
  end
end
