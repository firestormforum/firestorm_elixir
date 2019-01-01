defmodule FirestormWeb.UserSocket do
  @moduledoc false
  @one_day 86_400

  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: FirestormWeb.Schema

  alias Absinthe.Phoenix.Socket

  def connect(%{"token" => token}, socket) do
    with {:ok, user_id} <-
           Phoenix.Token.verify(FirestormWeb.Endpoint, "user auth", token, max_age: @one_day),
         {:ok, user} <- FirestormData.Users.get_user(user_id) do
      socket = Socket.put_options(socket, context: %{current_user: user})
      {:ok, socket}
    else
      _ -> :error
    end
  end

  def connect(_, socket) do
    {:ok, socket}
  end

  def id(%{assigns: %{absinthe: %{opts: [context: %{current_user: user}]}}}) do
    "user_socket:#{user.id}"
  end

  def id(_), do: nil
end
