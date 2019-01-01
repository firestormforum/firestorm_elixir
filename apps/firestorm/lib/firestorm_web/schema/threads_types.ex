defmodule FirestormWeb.Schema.ThreadsTypes do
  use Absinthe.Schema.Notation
  alias FirestormWeb.Resolvers

  object :thread do
    field(:id, non_null(:id))
    field(:title, non_null(:string))

    field(:posts, non_null(list_of(non_null(:post)))) do
      resolve(&Resolvers.Posts.list_posts/3)
    end

    field(:inserted_at, non_null(:datetime))
    field(:updated_at, non_null(:datetime))
  end
end
