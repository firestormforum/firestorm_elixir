defmodule FirestormData.ThreadsTest do
  use FirestormData.DataCase

  import FirestormData.Threads

  alias FirestormData.{
    Categories,
    Threads.Thread,
    Users
  }

  setup do
    {:ok, category} = Categories.create_category(%{title: "New Category"})

    {:ok, user} =
      Users.create_user(%{
        username: "knewter",
        name: "Josh Adams",
        email: "josh@smoothterminal.com"
      })

    {:ok, category: category, user: user}
  end

  test "create_thread/3 with valid data creates a thread and its first post", %{
    category: category,
    user: user
  } do
    attrs = %{title: "Some title", body: "First post"}
    assert {:ok, %Thread{} = thread} = create_thread(category, user, attrs)
    assert thread.title == attrs.title
    first_post = hd(thread.posts)
    assert first_post.thread_id == thread.id
    assert first_post.body == "First post"
  end

  test "get_thread returns the thread with given id", %{
    category: category,
    user: user
  } do
    {:ok, %Thread{id: id}} =
      create_thread(category, user, %{title: "New Title", body: "First post"})

    assert {:ok, %Thread{id: ^id}} = get_thread(category, id)
  end

  test "create_thread/3 with invalid data returns error changeset", %{
    category: category,
    user: user
  } do
    assert {:error, changeset} = create_thread(category, user, %{title: nil})
    assert "can't be blank" in errors_on(changeset).title
  end

  test "update_thread/2 with valid data updates the thread", %{
    category: category,
    user: user
  } do
    {:ok, thread = %Thread{}} =
      create_thread(category, user, %{title: "New Title", body: "First post"})

    updated_attrs = %{title: "some updated title"}
    assert {:ok, %Thread{} = thread} = update_thread(thread, updated_attrs)
    assert thread.title == updated_attrs.title
  end

  test "update_thread/2 with invalid data returns error changeset", %{
    category: category,
    user: user
  } do
    {:ok, thread = %Thread{}} =
      create_thread(category, user, %{title: "New Title", body: "First Post"})

    assert {:error, changeset} = update_thread(thread, %{title: nil})
    assert "can't be blank" in errors_on(changeset).title
  end

  test "delete_thread/1 deletes the thread", %{
    category: category,
    user: user
  } do
    {:ok, thread = %Thread{}} =
      create_thread(category, user, %{title: "New Title", body: "First Post"})

    assert {:ok, %Thread{}} = delete_thread(thread)
    assert {:error, :no_such_thread} = get_thread(category, thread.id)
  end

  test "list_threads/1 fetches threads for the given category", %{
    category: category,
    user: user
  } do
    {:ok, thread = %Thread{}} =
      create_thread(category, user, %{title: "New Title", body: "First Post"})

    threads = list_threads(category)
    assert thread.id in Enum.map(threads, & &1.id)
  end
end
