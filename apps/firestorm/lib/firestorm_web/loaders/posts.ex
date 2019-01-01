defmodule FirestormWeb.Loaders.Posts do
  def data do
    Dataloader.Ecto.new(FirestormData.Repo)
  end
end
