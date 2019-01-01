defmodule FirestormWeb.Resolvers.Users do
  def gravatar(user, _, _) do
    {:ok, Gravity.image(user.email)}
  end

  def create_user(_, args, _) do
    FirestormData.Users.create_user(args)
  end

  def authenticate(_, %{email: email, password: password}, _) do
    with {:ok, user} <- FirestormData.Users.find_user(%{email: email}) do
      # FIXME：This is a bit of data leakage - why does the graphql interface know that the data layer uses Comeonin.Bcrypt?
      case Comeonin.Bcrypt.checkpw(password, user.password_hash) do
        true ->
          # Everything checks out, success
          {:ok, sign_auth_token(user.id)}

        _ ->
          # User existed, we checked the password, but no dice
          {:error, "No user found with that username or password"}
      end
    end
  end

  defp sign_auth_token(id), do: Phoenix.Token.sign(FirestormWeb.Endpoint, "user auth", id)
end
