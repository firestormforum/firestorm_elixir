defmodule FirestormData.CategoriesTest do
  use FirestormData.DataCase

  import FirestormData.Categories

  alias FirestormData.{
    Categories.Category,
    Repo,
    Threads,
    Threads.Thread,
    Users
  }

  test "create_category/1 with valid data creates a category" do
    attrs = %{title: "some title"}
    assert {:ok, %Category{} = category} = create_category(attrs)
    assert category.title == "some title"
    assert category.slug == "some-title"
  end

  test "categories have many threads" do
    {:ok, user} =
      Users.create_user(%{
        username: "knewter",
        name: "Josh Adams",
        email: "josh@smoothterminal.com"
      })

    attrs = %{title: "some title"}
    {:ok, %Category{} = category} = create_category(attrs)

    {:ok, %Thread{id: thread_id}} =
      Threads.create_thread(
        category,
        user,
        %{title: "Thread", body: "First post"}
      )

    category = Repo.preload(category, [:threads])
    assert thread_id in Enum.map(category.threads, & &1.id)
  end
end
