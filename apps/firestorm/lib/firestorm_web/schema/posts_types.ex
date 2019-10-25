defmodule FirestormWeb.Schema.PostsTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  object :post do
    field(:id, non_null(:id))
    field(:body, non_null(:string))
    field(:user, non_null(:user), resolve: dataloader(FirestormData.Posts.Post))
    field(:thread, non_null(:thread), resolve: dataloader(FirestormData.Posts.Post))
    field(:inserted_at, non_null(:datetime))
    field(:updated_at, non_null(:datetime))
  end
end
