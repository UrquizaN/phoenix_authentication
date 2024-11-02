defmodule ElixirAuthWeb.Auth.Guardian do
  use Guardian, otp_app: :elixir_auth

  alias ElixirAuth.Accounts

  def subject_for_token(%{id: id}, _claims), do: {:ok, to_string(id)}

  def resource_from_claims(%{"sub" => id} = _claims) do
    case Accounts.get_account!(id) do
      nil -> {:error, :resource_not_found}
      resource -> {:ok, resource}
    end
  end

  def authenticate(email, password) do
    case Accounts.get_account_by_email(email) do
      nil ->
        {:error, :unauthorized}

      account ->
        case validate_password(password, account.hashed_password) do
          true -> create_token(account)
          false -> {:error, :unauthorized}
        end
    end
  end

  defp validate_password(password, hashed_password) do
    Bcrypt.verify_pass(password, hashed_password)
  end

  defp create_token(account) do
    {:ok, token, _claims} = encode_and_sign(account)
    {:ok, account, token}
  end
end
