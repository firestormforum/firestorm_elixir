defmodule FirestormWeb.Loaders.Threads do
  def data do
    Dataloader.Ecto.new(FirestormData.Repo)
  end
end
