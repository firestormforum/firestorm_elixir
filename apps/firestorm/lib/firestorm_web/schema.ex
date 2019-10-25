defmodule FirestormWeb.Schema do
  use Absinthe.Schema
  import_types(FirestormWeb.Schema.CategoriesTypes)
  import_types(FirestormWeb.Schema.ThreadsTypes)
  import_types(FirestormWeb.Schema.PostsTypes)
  import_types(FirestormWeb.Schema.UsersTypes)
  import_types(FirestormWeb.Schema.PaginationTypes)

  alias FirestormWeb.Resolvers

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(FirestormData.Posts.Post, FirestormWeb.Loaders.Posts.data())
      |> Dataloader.add_source(FirestormData.Threads.Thread, FirestormWeb.Loaders.Threads.data())

    Map.put(ctx, :loader, loader)
  end

  @desc """
  The `DateTime` scalar type represents a date and time in the UTC
  timezone. The DateTime appears in a JSON response as an ISO8601 formatted
  string, including UTC timezone ("Z"). The parsed date and time string will
  be converted to UTC and any UTC offset other than 0 will be rejected.
  """
  scalar :datetime, name: "DateTime" do
    serialize(&DateTime.to_iso8601/1)
    parse(&parse_datetime/1)
  end

  @spec parse_datetime(Absinthe.Blueprint.Input.String.t()) :: {:ok, DateTime.t()} | :error
  @spec parse_datetime(Absinthe.Blueprint.Input.Null.t()) :: {:ok, nil}
  defp parse_datetime(%Absinthe.Blueprint.Input.String{value: value}) do
    case DateTime.from_iso8601(value) do
      {:ok, datetime, 0} -> {:ok, datetime}
      {:ok, _datetime, _offset} -> :error
      _error -> :error
    end
  end

  defp parse_datetime(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp parse_datetime(_) do
    :error
  end

  query do
    @desc "Get all categories"
    field(:categories, non_null(:paginated_categories)) do
      arg(:pagination, :pagination)
      resolve(&Resolvers.Categories.list_categories/3)
    end

    @desc "Get a specific category"
    field(:category, non_null(:category)) do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Categories.find_category/3)
    end

    @desc "Get a specific thread"
    field(:thread, non_null(:thread)) do
      arg(:id, non_null(:id))
      resolve(&Resolvers.Threads.find_thread/3)
    end
  end

  mutation do
    @desc "Create a user"
    field(:create_user, non_null(:user)) do
      arg(:username, non_null(:string))
      arg(:name, non_null(:string))
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.Users.create_user/3)
    end

    @desc "Authenticate and receive an authorization token"
    field(:authenticate, non_null(:string)) do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.Users.authenticate/3)
    end

    @desc "Create a category"
    field(:create_category, non_null(:category)) do
      arg(:title, non_null(:string))
      resolve(&Resolvers.Categories.create_category/3)
    end

    @desc "Create a thread"
    field(:create_thread, non_null(:thread)) do
      arg(:category_id, non_null(:id))
      arg(:title, non_null(:string))
      arg(:body, non_null(:string))
      resolve(&Resolvers.Threads.create_thread/3)
    end

    @desc "Create a post"
    field(:create_post, non_null(:post)) do
      arg(:thread_id, non_null(:id))
      arg(:body, non_null(:string))
      resolve(&Resolvers.Posts.create_post/3)
    end
  end

  subscription do
    @desc "Get notified when a category is added"
    field(:category_added, non_null(:category)) do
      config(fn _, _ ->
        {:ok, topic: :global}
      end)

      trigger(:create_category, topic: fn _ -> :global end)
    end

    @desc "Get notified when a thread is added"
    field(:thread_added, non_null(:thread)) do
      arg(:category_id, non_null(:id))

      config(fn args, _ ->
        {:ok, topic: args.category_id}
      end)

      trigger(:create_thread, topic: fn thread -> thread.category_id end)
    end

    @desc "Get notified when a post is added"
    field(:post_added, non_null(:post)) do
      arg(:thread_id, non_null(:id))

      config(fn args, _ ->
        {:ok, topic: args.thread_id}
      end)

      trigger(:create_post, topic: fn post -> post.thread_id end)
    end
  end
end
