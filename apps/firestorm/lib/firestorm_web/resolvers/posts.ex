defmodule FirestormWeb.Resolvers.Posts do
  alias FirestormData.{
    Posts,
    Threads.Thread,
    Users.User
  }

  def list_posts(%Thread{} = thread, _, _) do
    {:ok, Posts.list_posts(thread)}
  end

  def create_post(_, %{thread_id: thread_id, body: body}, %{
        context: %{current_user: %User{} = current_user}
      }) do
    with {:ok, thread} <- FirestormData.Threads.get_thread(thread_id),
         do: FirestormData.Posts.create_post(thread, current_user, %{body: body})
  end

  def create_post(_, _, _), do: {:error, :unauthorized}
end
