defmodule Firestorm.Absinthe.Mutations.UsersTest do
  use FirestormWeb.ConnCase
  alias FirestormWeb.Schema
  alias FirestormData.Users

  @email "josh@smoothterminal.com"
  @name "Josh Adams"
  @username "knewter"
  @password "password"

  test "creating a user" do
    query = """
    mutation {
      createUser(email: "#{@email}", name: "#{@name}", username: "#{@username}", password: "#{
      @password
    }") {
        id
        name
        username
        avatarUrl
      }
    }
    """

    context = %{}

    {:ok, %{data: %{"createUser" => user}}} = Absinthe.run(query, Schema, context: context)

    assert user["id"]
    assert user["name"] == @name
    assert user["username"] == @username
    assert user["avatarUrl"] == Gravity.image(@email)
  end

  test "authentication" do
    {:ok, user} =
      Users.create_user(%{
        username: @username,
        email: @email,
        password: @password,
        name: @name
      })

    query = """
    mutation {
      authenticate(email: "#{@email}", password: "#{@password}")
    }
    """

    context = %{}

    {:ok, %{data: %{"authenticate" => token}}} = Absinthe.run(query, Schema, context: context)

    assert {:ok, user.id} ==
             Phoenix.Token.verify(FirestormWeb.Endpoint, "user auth", token, max_age: 86400)
  end
end
