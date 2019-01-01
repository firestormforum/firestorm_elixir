defmodule Firestorm.Absinthe.Mutations.ThreadsTest do
  use FirestormWeb.ConnCase
  alias FirestormWeb.Schema

  alias FirestormData.{
    Categories,
    Users
  }

  @email "josh@smoothterminal.com"
  @name "Josh Adams"
  @username "knewter"
  @password "password"
  @category_title "Some category"
  @title "Some thread"
  @body "First post"

  setup do
    {:ok, category} = Categories.create_category(%{title: @category_title})

    {:ok, user} =
      Users.create_user(%{
        username: @username,
        email: @email,
        password: @password,
        name: @name
      })

    {:ok, category: category, user: user}
  end

  test "creating a thread without a user fails", %{category: category} do
    context = %{}

    {:ok, %{errors: errors}} =
      Absinthe.run(create_thread_query(category), Schema, context: context)

    assert "unauthorized" in Enum.map(errors, & &1.message)
  end

  test "creating a thread", %{
    category: category,
    user: user
  } do
    context = %{current_user: user}

    {:ok, %{data: %{"createThread" => thread}}} =
      Absinthe.run(create_thread_query(category), Schema, context: context)

    assert thread["id"]
    assert thread["title"] == @title
    assert [first_post] = thread["posts"]
    assert first_post["id"]
    assert first_post["body"] == @body
    assert first_post["user"]["username"] == @username
    assert first_post["user"]["name"] == @name
  end

  defp create_thread_query(category) do
    """
    mutation {
      createThread(title: "#{@title}", body: "#{@body}", categoryId: "#{category.id}") {
        id
        title
        posts {
          id
          body
          user {
            id
            username
            name
          }
        }
      }
    }
    """
  end
end
