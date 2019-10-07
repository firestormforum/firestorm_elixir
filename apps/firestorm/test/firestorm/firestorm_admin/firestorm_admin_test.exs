defmodule Firestorm.FirestormAdminTest do
  use FirestormData.DataCase

  alias Firestorm.FirestormAdmin

  describe "categories" do
    alias FirestormData.Categories.Category

    @valid_attrs %{
      inserted_at: ~N[2010-04-17 14:00:00],
      slug: "some slug",
      title: "some title",
      updated_at: ~N[2010-04-17 14:00:00]
    }
    @update_attrs %{
      inserted_at: ~N[2011-05-18 15:01:01],
      slug: "some updated slug",
      title: "some updated title",
      updated_at: ~N[2011-05-18 15:01:01]
    }
    @invalid_attrs %{inserted_at: nil, slug: nil, title: nil, updated_at: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> FirestormAdmin.create_category()

      category
    end

    test "paginate_categories/1 returns paginated list of categories" do
      for _ <- 1..20 do
        category_fixture()
      end

      {:ok, %{categories: categories} = page} = FirestormAdmin.paginate_categories(%{})

      assert length(categories) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert FirestormAdmin.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert FirestormAdmin.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = FirestormAdmin.create_category(@valid_attrs)
      assert category.inserted_at == ~N[2010-04-17 14:00:00]
      assert category.slug == "some slug"
      assert category.title == "some title"
      assert category.updated_at == ~N[2010-04-17 14:00:00]
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FirestormAdmin.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, category} = FirestormAdmin.update_category(category, @update_attrs)
      assert %Category{} = category
      assert category.inserted_at == ~N[2011-05-18 15:01:01]
      assert category.slug == "some updated slug"
      assert category.title == "some updated title"
      assert category.updated_at == ~N[2011-05-18 15:01:01]
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()

      assert {:error, %Ecto.Changeset{}} =
               FirestormAdmin.update_category(category, @invalid_attrs)

      assert category == FirestormAdmin.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = FirestormAdmin.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> FirestormAdmin.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = FirestormAdmin.change_category(category)
    end
  end

  describe "threads" do
    alias FirestormData.Threads.Thread

    @valid_attrs %{
      inserted_at: ~N[2010-04-17 14:00:00],
      slug: "some slug",
      title: "some title",
      # category_id: create_category(),
      updated_at: ~N[2010-04-17 14:00:00]
    }
    @update_attrs %{
      inserted_at: ~N[2011-05-18 15:01:01],
      slug: "some updated slug",
      title: "some updated title",
      updated_at: ~N[2011-05-18 15:01:01]
    }
    @invalid_attrs %{inserted_at: nil, slug: nil, title: nil, updated_at: nil}

    # def create_category() do
    #   cat_valid_attrs(%{
    #     inserted_at: ~N[2010-04-17 14:00:00],
    #     slug: "some slug",
    #     title: "some title",
    #     updated_at: ~N[2010-04-17 14:00:00]
    #   })

    #   {:ok, category} =
    #     Enum.into(cat_valid_attrs)
    #     |> FirestormAdmin.create_category()

    #   category
    # end

    def thread_fixture(attrs \\ %{}) do
      {:ok, thread} =
        attrs
        |> Enum.into(@valid_attrs)
        |> FirestormAdmin.create_thread()

      thread
    end

    test "paginate_threads/1 returns paginated list of threads" do
      for _ <- 1..20 do
        thread_fixture()
      end

      {:ok, %{threads: threads} = page} = FirestormAdmin.paginate_threads(%{})

      assert length(threads) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_threads/0 returns all threads" do
      thread = thread_fixture()
      assert FirestormAdmin.list_threads() == [thread]
    end

    test "get_thread!/1 returns the thread with given id" do
      thread = thread_fixture()
      assert FirestormAdmin.get_thread!(thread.id) == thread
    end

    test "create_thread/1 with valid data creates a thread" do
      assert {:ok, %Thread{} = thread} = FirestormAdmin.create_thread(@valid_attrs)
      assert thread.inserted_at == ~N[2010-04-17 14:00:00]
      assert thread.slug == "some slug"
      assert thread.title == "some title"
      assert thread.updated_at == ~N[2010-04-17 14:00:00]
    end

    test "create_thread/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FirestormAdmin.create_thread(@invalid_attrs)
    end

    test "update_thread/2 with valid data updates the thread" do
      thread = thread_fixture()
      assert {:ok, thread} = FirestormAdmin.update_thread(thread, @update_attrs)
      assert %Thread{} = thread
      assert thread.inserted_at == ~N[2011-05-18 15:01:01]
      assert thread.slug == "some updated slug"
      assert thread.title == "some updated title"
      assert thread.updated_at == ~N[2011-05-18 15:01:01]
    end

    test "update_thread/2 with invalid data returns error changeset" do
      thread = thread_fixture()
      assert {:error, %Ecto.Changeset{}} = FirestormAdmin.update_thread(thread, @invalid_attrs)
      assert thread == FirestormAdmin.get_thread!(thread.id)
    end

    test "delete_thread/1 deletes the thread" do
      thread = thread_fixture()
      assert {:ok, %Thread{}} = FirestormAdmin.delete_thread(thread)
      assert_raise Ecto.NoResultsError, fn -> FirestormAdmin.get_thread!(thread.id) end
    end

    test "change_thread/1 returns a thread changeset" do
      thread = thread_fixture()
      assert %Ecto.Changeset{} = FirestormAdmin.change_thread(thread)
    end
  end
end
