defmodule ElixirAuthWeb.Auth.ErrorResponse.Unauthorized do
  defexception message: "Unauthorized", plug_status: 401
end

defmodule ElixirAuthWeb.Auth.ErrorResponse.Forbidden do
  defexception message: "You do not have access to this resource", plug_status: 403
end
