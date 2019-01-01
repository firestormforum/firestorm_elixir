defmodule FirestormData.PostsTest do
  use FirestormData.DataCase

  import FirestormData.Posts

  alias FirestormData.{
    Categories,
    Threads,
    Users,
    Posts.Post
  }

  setup do
    {:ok, category} = Categories.create_category(%{title: "Category"})

    {:ok, user} =
      Users.create_user(%{
        username: "knewter",
        name: "Josh Adams",
        email: "josh@smoothterminal.com"
      })

    {:ok, thread} = Threads.create_thread(category, user, %{title: "Thread", body: "First post"})

    {:ok, thread: thread, user: user}
  end

  test "creating a post in a thread", %{thread: thread, user: user} do
    assert {:ok, %Post{} = post} = create_post(thread, user, %{body: "Post body"})
    assert post.thread_id == thread.id
    assert post.body == "Post body"
    assert post.user_id == user.id
  end

  test "getting the posts for a thread", %{thread: thread, user: user} do
    assert {:ok, %Post{} = post} = create_post(thread, user, %{body: "Post body"})
    posts = list_posts(thread)
    assert post.id in Enum.map(posts, & &1.id)
  end
end
