defmodule FirestormWeb.Context do
  import Plug.Conn
  @behaviour Plug
  @one_day 86_400

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user} <- authorize(token) do
      %{current_user: current_user}
    else
      _ -> %{}
    end
  end

  defp authorize(token) do
    with {:ok, user_id} <-
           Phoenix.Token.verify(FirestormWeb.Endpoint, "user auth", token, max_age: @one_day) do
      FirestormData.Users.get_user(user_id)
    else
      _ -> {:error, "invalid authorization token"}
    end
  end
end
