defmodule ElixirAuth.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :email, :string
    field :hashed_password, :string
    field :password, :string, virtual: true
    has_one(:user, ElixirAuth.Users.User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:email, max: 160)
    |> unique_constraint(:email)
    |> put_hashed_password()
  end

  defp put_hashed_password(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, hashed_password: Bcrypt.hash_pwd_salt(password))
  end

  defp put_hashed_password(changeset), do: changeset
end
