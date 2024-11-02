defmodule ElixirAuthWeb.AccountController do
  use ElixirAuthWeb, :controller

  alias ElixirAuth.Accounts
  alias ElixirAuth.Accounts.Account
  alias ElixirAuth.Users
  alias ElixirAuth.Users.User
  alias ElixirAuthWeb.Auth.Guardian
  alias ElixirAuthWeb.Auth.ErrorResponse

  action_fallback ElixirAuthWeb.FallbackController

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, :index, accounts: accounts)
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:ok, account, token} ->
        conn
        |> Plug.Conn.put_session(:account_id, account.id)
        |> render(:data_with_token, %{account: account, token: token})

      {:error, :unauthorized} ->
        raise ErrorResponse,
          message: "Email or password is incorrect"
    end
  end

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(account),
         {:ok, %User{} = _user} <- Users.create_user(account, account_params) do
      conn
      |> put_status(:created)
      |> render(:data_with_token, %{account: account, token: token})
    end
  end

  def show(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)
    render(conn, :show, account: account)
  end

  def update(conn, %{"id" => id, "account" => account_params}) do
    account = Accounts.get_account!(id)

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
