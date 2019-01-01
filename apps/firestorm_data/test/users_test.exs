defmodule FirestormData.UsersTest do
  use FirestormData.DataCase

  import FirestormData.Users
  alias FirestormData.Users.User

  @attrs %{
    email: "josh@smoothterminal.com",
    name: "Josh Adams",
    username: "knewter"
  }

  test "create_user/1 with valid data creates a user" do
    assert {:ok, %User{} = user} = create_user(@attrs)
    assert user.email == @attrs.email
    assert user.name == @attrs.name
    assert user.username == @attrs.username
  end

  test "create_user/1 with valid data creates a user with a password" do
    assert {:ok, %User{} = user} = create_user(Map.put(@attrs, :password, "somepassword"))
    assert user.email == @attrs.email
    assert user.name == @attrs.name
    assert user.username == @attrs.username
    assert user.password_hash
  end

  test "create_user/1 with invalid data returns error changeset" do
    assert {:error, changeset} = create_user(Map.delete(@attrs, :username))
    assert "can't be blank" in errors_on(changeset).username
  end

  test "get_user returns the user with given id" do
    {:ok, user} = create_user(@attrs)
    assert {:ok, %User{}} = get_user(user.id)
  end

  test "update_user/2 with valid data updates the user" do
    {:ok, user} = create_user(@attrs)
    updated_attrs = %{email: "updated@example.com", name: "New name", username: "new_username"}
    assert {:ok, user = %User{}} = update_user(user, updated_attrs)
    assert user.email == updated_attrs.email
    assert user.name == updated_attrs.name
    assert user.username == updated_attrs.username
  end

  test "update_user/2 with invalid data returns error changeset" do
    {:ok, user} = create_user(@attrs)
    assert {:error, changeset} = update_user(user, %{username: nil})
    assert "can't be blank" in errors_on(changeset).username
  end

  test "delete_user/1 deletes the user" do
    {:ok, user} = create_user(@attrs)
    assert {:ok, %User{}} = delete_user(user)
    assert {:error, :no_such_user} = get_user(user.id)
  end

  test "find_user/1 finds a user with the provided attributes" do
    {:ok, _} = create_user(@attrs)
    assert {:ok, %User{}} = find_user(%{email: @attrs.email})
  end
end
