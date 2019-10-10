defmodule FirestormWeb.Plug.EnsureAdmin do
  @moduledoc """
  This plug makes sure that the authenticated user is a super user,
  otherwise it halts the connection.
  """
  import Plug.Conn
  import Phoenix.Controller
  alias FirestormData.Repo
  alias FirestormData.Users.User
  alias FirestormWeb.Router.Helpers, as: Routes

  def init(opts), do: Enum.into(opts, %{})

  def call(conn, opts \\ []) do
    check_admin(conn, opts)
  end

  defp check_admin(conn, _opts) do
    case get_session(conn, :current_user_id) do
      nil ->
        halt_plug(conn)

      current_user_id ->
        case Repo.get(User, current_user_id) do
          nil ->
            halt_plug(conn)

          current_user ->
            case current_user.admin do
              false -> halt_plug(conn)
              true -> assign(conn, :current_user, current_user)
            end
        end
    end
  end

  defp halt_plug(conn) do
    conn
    |> redirect(to: Routes.auth_path(conn, :login))
    |> halt()
  end
end
