defmodule Firestorm.Absinthe.Queries.CategoriesTest do
  use FirestormWeb.ConnCase
  alias FirestormWeb.Schema

  alias FirestormData.{
    Categories,
    Threads,
    Users
  }

  @title "Some category"

  test "getting a paginated list of categories without passing explicit pagination options returns all results" do
    query = """
    {
      categories {
        totalPages
        totalEntries
        page
        perPage
        entries {
          id
          title
        }
      }
    }
    """

    context = %{}

    {:ok, %{data: %{"categories" => categories}}} = Absinthe.run(query, Schema, context: context)

    assert [] == categories["entries"]
    assert categories["page"] == 1

    assert categories["perPage"] == 20
    assert categories["totalPages"] == 1
    assert categories["totalEntries"] == 0
  end

  test "get a paginated list of categories" do
    {:ok, _} = Categories.create_category(%{title: @title})

    query = """
    {
      categories(pagination: {page: 1, perPage: 2}) {
        totalPages
        totalEntries
        page
        perPage
        entries {
          id
          title
        }
      }
    }
    """

    context = %{}

    {:ok, %{data: %{"categories" => categories}}} = Absinthe.run(query, Schema, context: context)

    assert [first_category] = categories["entries"]
    assert first_category["title"] == @title
    assert categories["page"] == 1
    assert categories["perPage"] == 2
    assert categories["totalPages"] == 1
    assert categories["totalEntries"] == 1
  end

  test "getting a category by id" do
    {:ok, category} = Categories.create_category(%{title: @title})

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
      category(id: "#{category.id}") {
        id
        title
        threads {
          id
          title
          insertedAt
          updatedAt
        }
      }
    }
    """

    context = %{}

    {:ok, %{data: %{"category" => returned_category}}} =
      Absinthe.run(query, Schema, context: context)

    assert returned_category["id"] == category.id
    assert returned_category["title"] == category.title
    assert [first_thread] = returned_category["threads"]
    assert first_thread["id"] == thread.id
    assert first_thread["title"] == thread.title
    assert first_thread["insertedAt"]
    assert first_thread["updatedAt"]
  end
end
