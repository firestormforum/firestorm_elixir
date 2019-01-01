defmodule FirestormData.Users.User do
  @moduledoc """
  Schema for forum users.
  """

  use FirestormData.Data, :model
  alias FirestormData.Users.User

  @type t :: %User{
          email: String.t(),
          name: String.t(),
          username: String.t(),
          password_hash: String.t(),
          password: nil | String.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "firestorm_users_users" do
    field(:email, :string)
    field(:name, :string)
    field(:username, :string)
    field(:password_hash, :string)
    field(:password, :string, virtual: true)

    timestamps()
  end

  @required_fields ~w(username)a
  @optional_fields ~w(email name)a

  def changeset(%__MODULE__{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:username)
  end

  def registration_changeset(%__MODULE__{} = user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password])
    |> validate_length(:password, min: 6)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        changeset
        |> put_change(:password_hash, Comeonin.Bcrypt.hashpwsalt(pass))

      _ ->
        changeset
    end
  end
end
