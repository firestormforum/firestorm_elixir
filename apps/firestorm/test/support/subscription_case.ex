defmodule FirestormWeb.SubscriptionCase do
  @moduledoc """
  This module defines the test case to be used by
  subscription tests.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      use FirestormWeb.ChannelCase
      use Absinthe.Phoenix.SubscriptionTest, schema: FirestormWeb.Schema
      alias FirestormData.Users

      setup do
        {:ok, user} =
          Users.create_user(%{
            email: "josh@smoothterminal.com",
            name: "Josh Adams",
            username: "knewter"
          })

        params = %{
          "token" => sign_auth_token(user.id)
        }

        {:ok, socket} = Phoenix.ChannelTest.connect(FirestormWeb.UserSocket, params)
        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, socket: socket, user: user}
      end

      defp sign_auth_token(id), do: Phoenix.Token.sign(FirestormWeb.Endpoint, "user auth", id)
    end
  end
end
