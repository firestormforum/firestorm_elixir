defmodule FirestormWeb.Schema.UsersTypes do
  use Absinthe.Schema.Notation
  alias FirestormWeb.Resolvers

  object :user do
    field(:id, non_null(:id))
    field(:username, non_null(:string))
    field(:name, non_null(:string))
    field(:avatar_url, non_null(:string), resolve: &Resolvers.Users.gravatar/3)
    field(:inserted_at, non_null(:datetime))
    field(:updated_at, non_null(:datetime))
  end
end
