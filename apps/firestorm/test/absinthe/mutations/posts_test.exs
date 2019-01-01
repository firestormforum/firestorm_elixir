defmodule Firestorm.Absinthe.Mutations.PostsTest do
  use FirestormWeb.ConnCase
  alias FirestormWeb.Schema

  alias FirestormData.{
    Categories,
    Threads,
    Users
  }

  @email "josh@smoothterminal.com"
  @name "Josh Adams"
  @username "knewter"
  @password "password"
  @category_title "Some category"
  @thread_title "Some thread"
  @first_post_body "First post"
  @body "Second post"

  setup do
    {:ok, category} = Categories.create_category(%{title: @category_title})

    {:ok, user} =
      Users.create_user(%{
        username: @username,
        email: @email,
        password: @password,
        name: @name
      })

    {:ok, thread} =
      Threads.create_thread(category, user, %{
        title: @thread_title,
        body: @first_post_body
      })

    {:ok, user: user, thread: thread}
  end

  test "creating a post without a user fails", %{
    thread: thread
  } do
    context = %{}

    {:ok, %{errors: errors}} = Absinthe.run(create_post_query(thread), Schema, context: context)

    assert "unauthorized" in Enum.map(errors, & &1.message)
  end

  test "creating a post", %{
    thread: thread,
    user: user
  } do
    context = %{current_user: user}

    {:ok, %{data: %{"createPost" => post}}} =
      Absinthe.run(create_post_query(thread), Schema, context: context)

    assert post["id"]
    assert post["body"] == @body
    assert post["user"]["username"] == @username
    assert post["user"]["name"] == @name
  end

  defp create_post_query(thread) do
    """
    mutation {
      createPost(body: "#{@body}", threadId: "#{thread.id}") {
        id
        body
        user {
          id
          username
          name
        }
      }
    }
    """
  end
end
