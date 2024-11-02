defmodule ElixirAuthWeb.DefaultController do
  use ElixirAuthWeb, :controller

  def index(conn, _params) do
    text(conn, "Elixir Auth is Live - #{Mix.env()}")
  end
end
