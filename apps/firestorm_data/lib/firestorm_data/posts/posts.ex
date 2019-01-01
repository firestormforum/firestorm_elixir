defmodule FirestormData.Posts do
  @moduledoc """
  Posts exist on Threads
  """

  import Ecto.Query

  alias FirestormData.{
    Repo,
    Posts.Post,
    Threads.Thread,
    Users.User
  }

  @doc """
  Creates a post within a thread.

  ## Examples

      iex> create_post(thread, user, %{body: "don't you think?"})
      {:ok, %Post{}}

      iex> create_post(thread, user, %{body: nil_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(%Thread{} = thread, %User{} = user, attrs) do
    attrs =
      attrs
      |> Map.put(:thread_id, thread.id)
      |> Map.put(:user_id, user.id)

    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def list_posts(%Thread{id: thread_id}) do
    Post
    |> where([p], p.thread_id == ^thread_id)
    |> order_by([p], desc: p.inserted_at)
    |> Repo.all()
  end
end
