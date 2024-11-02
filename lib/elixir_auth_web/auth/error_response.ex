defmodule ElixirAuthWeb.Auth.ErrorResponse do
  defexception message: "Unauthorized", plug_status: 401
end
