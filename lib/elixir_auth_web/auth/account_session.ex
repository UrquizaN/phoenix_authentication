defmodule ElixirAuthWeb.Auth.AccountSession do
  import Plug.Conn
  alias ElixirAuthWeb.Auth.ErrorResponse
  alias ElixirAuth.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns[:current_account] do
      conn
    else
      account_id = get_session(conn, :account_id)

      if is_nil(account_id), do: raise(ErrorResponse)

      account = Accounts.get_account!(account_id)

      assign(conn, :current_account, account)
    end
  end
end
