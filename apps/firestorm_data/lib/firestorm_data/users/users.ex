defmodule FirestormData.Users do
  @moduledoc """
  Users can interact with the forum in an authenticated manner.
  """

  alias FirestormData.{
    Repo,
    Users.User
  }

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_user(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @spec get_user(String.t()) :: {:ok, User.t()} | {:error, :no_such_user}
  def get_user(id) do
    case Repo.get(User, id) do
      nil -> {:error, :no_such_user}
      user -> {:ok, user}
    end
  end

  @spec delete_user(User.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def delete_user(user = %User{}) do
    Repo.delete(user)
  end

  @spec update_user(User.t(), map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def update_user(user = %User{}, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @spec find_user(map()) :: {:ok, User.t()} | {:error, :no_such_user}
  def find_user(attrs \\ %{}) do
    User
    |> Repo.get_by(attrs)
    |> case do
      nil -> {:error, :no_such_user}
      user -> {:ok, user}
    end
  end
end
