defmodule FirestormWeb.Resolvers.Categories do
  alias FirestormData.Users.User

  def list_categories(_, args, _) do
    {:ok, FirestormData.Categories.list_categories(args)}
  end

  def find_category(_, %{id: id}, _) do
    FirestormData.Categories.find_category(%{id: id})
  end

  def create_category(_, args, %{context: %{current_user: %User{}}}) do
    FirestormData.Categories.create_category(args)
  end

  def create_category(_, _, _) do
    {:error, "unauthorized"}
  end
end
