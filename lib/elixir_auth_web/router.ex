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
  end

  pipeline :auth do
    plug ElixirAuthWeb.Auth.Pipeline
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
  end
end
