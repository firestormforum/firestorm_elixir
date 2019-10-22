defmodule Firestorm.FirestormAdminTest do
  use FirestormData.DataCase
  import Firestorm.Factory

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

    def category_fixture() do
      {:ok, category} = insert(:category)

      category
    end

    test "paginate_categories/1 returns paginated list of categories" do
      for _ <- 1..20 do
        insert(:category)
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
      category = insert(:category)
      assert FirestormAdmin.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = insert(:category)
      assert FirestormAdmin.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = FirestormAdmin.create_category(@valid_attrs)
      assert category.title == "some title"
      assert category.slug == "some-title"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FirestormAdmin.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = insert(:category)
      assert {:ok, category} = FirestormAdmin.update_category(category, @update_attrs)
      assert %Category{} = category
      assert category.title == "some updated title"
      assert category.slug == "some-updated-title"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = insert(:category)

      assert {:error, %Ecto.Changeset{}} =
               FirestormAdmin.update_category(category, @invalid_attrs)

      assert category == FirestormAdmin.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = insert(:category)
      assert {:ok, %Category{}} = FirestormAdmin.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> FirestormAdmin.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = insert(:category)
      assert %Ecto.Changeset{} = FirestormAdmin.change_category(category)
    end
  end

  describe "threads" do
    alias FirestormData.Threads.Thread

    @valid_attrs %{
      title: "some title"
    }

    @invalid_attrs %{inserted_at: nil, slug: nil, title: nil, updated_at: nil}

    test "paginate_threads/1 returns paginated list of threads" do
      for _ <- 1..20 do
        insert(:thread)
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
      thread = insert(:thread)
      assert FirestormAdmin.list_threads() == [thread]
    end

    test "get_thread!/1 returns the thread with given id" do
      thread = insert(:thread)
      assert FirestormAdmin.get_thread!(thread.id) == thread
    end

    test "create_thread/1 with valid data creates a thread" do
      category = insert(:category)

      attrs = %{category_id: category.id, title: "some title"}
      assert {:ok, %Thread{} = thread} = FirestormAdmin.create_thread(attrs)
      assert thread.title == "some title"
      assert thread.slug == "some-title"
    end

    test "create_thread/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FirestormAdmin.create_thread(@invalid_attrs)
    end

    test "update_thread/2 with valid data updates the thread" do
      thread = insert(:thread)
      assert {:ok, thread} = FirestormAdmin.update_thread(thread, @update_attrs)
      assert %Thread{} = thread

      assert thread.title == "some updated title"
      assert thread.slug == "some-updated-title"
    end

    test "update_thread/2 with invalid data returns error changeset" do
      thread = insert(:thread)
      assert {:error, %Ecto.Changeset{}} = FirestormAdmin.update_thread(thread, @invalid_attrs)
      assert thread == FirestormAdmin.get_thread!(thread.id)
    end

    test "delete_thread/1 deletes the thread" do
      thread = insert(:thread)
      assert {:ok, %Thread{}} = FirestormAdmin.delete_thread(thread)
      assert_raise Ecto.NoResultsError, fn -> FirestormAdmin.get_thread!(thread.id) end
    end

    test "change_thread/1 returns a thread changeset" do
      thread = insert(:thread)
      assert %Ecto.Changeset{} = FirestormAdmin.change_thread(thread)
    end
  end

  describe "posts" do
    alias FirestormData.Posts.Post

    @valid_attrs %{
      body: "some body",
      user_id: "",
      thread_id: ""
    }
    @update_attrs %{
      body: "some updated body",
      inserted_at: ~N[2011-05-18 15:01:01],
      updated_at: ~N[2011-05-18 15:01:01]
    }
    @invalid_attrs %{body: nil, inserted_at: nil, updated_at: nil}

    test "paginate_posts/1 returns paginated list of posts" do
      for _ <- 1..20 do
        insert(:post)
      end

      {:ok, %{posts: posts} = page} = FirestormAdmin.paginate_posts(%{})

      assert length(posts) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_posts/0 returns all posts" do
      post = insert(:post)
      assert FirestormAdmin.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = insert(:post)
      assert FirestormAdmin.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      user = insert(:user)
      thread = insert(:thread)

      attrs = %{@valid_attrs | thread_id: thread.id}
      attrs = %{attrs | user_id: user.id}

      assert {:ok, %Post{} = post} = FirestormAdmin.create_post(attrs)
      assert post.body == "some body"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FirestormAdmin.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      user = insert(:user)
      thread = insert(:thread)
      post = insert(:post, user: user, thread: thread)

      assert {:ok, post} = FirestormAdmin.update_post(post, @update_attrs)
      assert %Post{} = post
      assert post.body == "some updated body"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = insert(:post)
      assert {:error, %Ecto.Changeset{}} = FirestormAdmin.update_post(post, @invalid_attrs)
      assert post == FirestormAdmin.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = insert(:post)
      assert {:ok, %Post{}} = FirestormAdmin.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> FirestormAdmin.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = insert(:post)
      assert %Ecto.Changeset{} = FirestormAdmin.change_post(post)
    end
  end

  describe "users" do
    alias FirestormData.Users.User

    @valid_attrs %{email: "some email", name: "some name", username: "some username"}
    @update_attrs %{
      email: "some updated email",
      name: "some updated name",
      username: "some updated username"
    }
    @invalid_attrs %{email: nil, name: nil, username: nil}

    test "paginate_users/1 returns paginated list of users" do
      for _ <- 1..20 do
        insert(:user)
      end

      {:ok, %{users: users} = page} = FirestormAdmin.paginate_users(%{})

      assert length(users) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_users/0 returns all users" do
      user = insert(:user)
      assert FirestormAdmin.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      assert FirestormAdmin.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = FirestormAdmin.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.name == "some name"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FirestormAdmin.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = insert(:user)
      assert {:ok, user} = FirestormAdmin.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert user.name == "some updated name"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = FirestormAdmin.update_user(user, @invalid_attrs)
      assert user == FirestormAdmin.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = insert(:user)
      assert {:ok, %User{}} = FirestormAdmin.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> FirestormAdmin.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = FirestormAdmin.change_user(user)
    end
  end
end
