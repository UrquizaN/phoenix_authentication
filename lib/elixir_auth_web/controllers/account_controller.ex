defmodule ElixirAuthWeb.AccountController do
  use ElixirAuthWeb, :controller

  alias ElixirAuth.Accounts
  alias ElixirAuth.Accounts.Account
  alias ElixirAuth.Users
  alias ElixirAuth.Users.User
  alias ElixirAuthWeb.Auth.Guardian
  alias ElixirAuthWeb.Auth.ErrorResponse.{Unauthorized, Forbidden}

  plug :authenticated_account when action in [:update, :delete]

  action_fallback ElixirAuthWeb.FallbackController

  def authenticated_account(conn, _opts) do
    %{params: %{"account" => params}} = conn

    account = Accounts.get_account!(params["id"])

    if conn.assigns.current_account.id == account.id do
      conn
    else
      raise Forbidden
    end
  end

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    authorize_account(conn, email, password)
  end

  def sign_out(conn, _params) do
    account = conn.assigns[:current_account]

    token = Guardian.Plug.current_token(conn)
    Guardian.revoke(token)

    conn
    |> Plug.Conn.clear_session()
    |> render(:data_with_token, %{account: account, token: nil})
  end

  def refresh_token(conn, _params) do
    token = Guardian.Plug.current_token(conn)

    {:ok, account, new_token} = Guardian.authenticate(token)

    conn
    |> Plug.Conn.put_session(:account_id, account.id)
    |> render(:data_with_token, %{account: account, token: new_token})
  end

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
         {:ok, %User{} = _user} <- Users.create_user(account, account_params) do
      authorize_account(conn, account.email, account_params["password"])
    end
  end

  defp authorize_account(conn, email, password) do
    case Guardian.authenticate(email, password) do
      {:ok, account, token} ->
        conn
        |> Plug.Conn.put_session(:account_id, account.id)
        |> render(:data_with_token, %{account: account, token: token})

      {:error, :unauthorized} ->
        raise Unauthorized,
          message: "Email or password is incorrect"
    end
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, :show, account: account)
  end

  def update(conn, %{"account" => account_params}) do
    account = Accounts.get_account!(account_params["id"])

    with {:ok, %Account{} = account} <- Accounts.update_account(account, account_params) do
      render(conn, :show, account: account)
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end
end
