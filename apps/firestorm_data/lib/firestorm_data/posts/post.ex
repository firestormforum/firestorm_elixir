defmodule FirestormData.Posts.Post do
  @moduledoc """
  Schema for forum posts.
  """

  use FirestormData.Data, :model

  alias FirestormData.{
    Threads.Thread,
    Posts.Post,
    Users.User
  }

  @type t :: %Post{
          id: String.t(),
          body: String.t(),
          thread: Thread.t() | %Ecto.Association.NotLoaded{},
          user: User.t() | %Ecto.Association.NotLoaded{},
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }
  schema "firestorm_posts_posts" do
    field(:body, :string)
    belongs_to(:thread, Thread)
    belongs_to(:user, User)

    timestamps()
  end

  def changeset(%__MODULE__{} = post, attrs \\ %{}) do
    post
    |> cast(attrs, [:body, :thread_id, :user_id])
    |> validate_required([:body, :thread_id, :user_id])
  end
end
