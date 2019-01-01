defmodule Firestorm.Absinthe.Mutations.CategoriesTest do
  use FirestormWeb.ConnCase
  alias FirestormWeb.Schema
  alias FirestormData.Users

  @email "josh@smoothterminal.com"
  @name "Josh Adams"
  @username "knewter"
  @password "password"
  @title "Some category"

  test "creating a category without a user fails" do
    context = %{}

    {:ok, %{errors: errors}} = Absinthe.run(create_category_query(), Schema, context: context)

    assert "unauthorized" in Enum.map(errors, & &1.message)
  end

  test "creating a category" do
    {:ok, user} =
      Users.create_user(%{
        username: @username,
        email: @email,
        password: @password,
        name: @name
      })

    context = %{current_user: user}

    {:ok, %{data: %{"createCategory" => category}}} =
      Absinthe.run(create_category_query(), Schema, context: context)

    assert category["id"]
    assert category["title"] == @title
  end

  defp create_category_query do
    """
    mutation {
      createCategory(title: "#{@title}") {
        id
        title
      }
    }
    """
  end
end
