defmodule ElixirAuthWeb.Router do
  use ElixirAuthWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ElixirAuthWeb do
    pipe_through :api

    resources "/", DefaultController, only: [:index]
    post "/accounts/create", AccountController, :create
  end
end
