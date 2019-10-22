defmodule FirestormWeb.AuthController do
  @one_day 86_400
  use FirestormWeb, :controller

  use Absinthe.Phoenix.Controller, schema: FirestormWeb.Schema

  def login(conn, _params) do
    conn
    |> render("login.html")
  end

  def logout(conn, _params) do
    conn
    |> fetch_session
    |> delete_session(:current_user_id)
    |> redirect(to: "/login")
  end

  def forgot_password_verification(conn, %{"token" => token}) do
    render(conn, "forgot_password_verification.html", token: token)
  end

  @graphql """
  mutation ($email: String, $password: String!) {
    authenticate(email: $email, password: $password)
  }
  """
  def authenticate(conn, params) do
    if params[:errors] do
      conn
      |> put_flash(
        :error,
        List.first(params[:errors])
        |> Map.get(:message)
      )
      |> redirect(to: "/login")
    else
      case find_user_by_token(params[:data]["authenticate"]) do
        nil ->
          conn
          |> put_flash(:error, "No luck")
          |> redirect(to: "/login")

        user ->
          conn
          |> put_session(:current_user_id, user.id)
          |> put_flash(:info, "Logged in successfully")
          |> redirect(to: "/admin/users")
      end
    end
  end

  def find_user_by_token(token) do
    with {:ok, user_id} <-
           Phoenix.Token.verify(FirestormWeb.Endpoint, "user auth", token, max_age: @one_day),
         {:ok, user} <- FirestormData.Users.get_user(user_id) do
      user
    else
      _ -> nil
    end
  end
end
