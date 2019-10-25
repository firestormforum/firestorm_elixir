defmodule FirestormWeb.Schema.ThreadsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers
  alias FirestormWeb.Resolvers

  object :thread do
    field(:id, non_null(:id))
    field(:title, non_null(:string))
    field(:slug, non_null(:string))

    field(:category, non_null(:category), resolve: dataloader(FirestormData.Threads.Thread))

    field(:posts, non_null(list_of(non_null(:post)))) do
      resolve(&Resolvers.Posts.list_posts/3)
    end

    field(:inserted_at, non_null(:datetime))
    field(:updated_at, non_null(:datetime))
  end
end
