defmodule FirestormWeb.Resolvers.Threads do
  alias FirestormData.{
    Categories.Category,
    Threads,
    Users.User
  }

  def list_threads(%Category{} = category, _, _) do
    {:ok, Threads.list_threads(category)}
  end

  def find_thread(_, %{id: id}, _) do
    Threads.get_thread(id)
  end

  def create_thread(_, %{category_id: category_id, title: title, body: body}, %{
        context: %{current_user: %User{} = current_user}
      }) do
    IO.puts("create_thread")

    with {:ok, category} <- FirestormData.Categories.find_category(%{id: category_id}),
         do:
           FirestormData.Threads.create_thread(category, current_user, %{title: title, body: body})
  end

  def create_thread(_, _, _) do
    IO.puts("create_thread unauth")
    {:error, "unauthorized"}
  end
end
