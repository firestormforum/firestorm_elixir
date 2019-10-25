defmodule Firestorm.Absinthe.Queries.ThreadsTest do
  use FirestormWeb.ConnCase
  alias FirestormWeb.Schema

  alias FirestormData.{
    Categories,
    Threads,
    Users
  }

  test "getting a thread by id" do
    {:ok, category} = Categories.create_category(%{title: "Some title"})

    {:ok, user} =
      Users.create_user(%{
        username: "knewter",
        name: "Josh Adams",
        email: "josh@smoothterminal.com"
      })

    {:ok, thread} =
      Threads.create_thread(category, user, %{title: "Thread title", body: "First post"})

    query = """
    {
      thread(id: "#{thread.id}") {
        id
        title
        slug
        category {
          id
        }
        posts {
          id
          body
          insertedAt
          updatedAt
          thread {
            id
          }
          user {
            id
            name
            username
            avatarUrl
          }
        }
      }
    }
    """

    context = %{}

    {:ok, %{data: %{"thread" => returned_thread}}} = Absinthe.run(query, Schema, context: context)

    assert returned_thread["id"] == thread.id
    assert returned_thread["title"] == thread.title
    assert returned_thread["slug"] == "thread-title"
    assert [first_post] = returned_thread["posts"]
    assert first_post["body"] == "First post"
    assert first_post["insertedAt"]
    assert first_post["updatedAt"]
    assert first_post["user"]["id"] == user.id
    assert first_post["user"]["name"] == user.name
    assert first_post["user"]["username"] == user.username
    assert first_post["user"]["avatarUrl"]
  end
end
