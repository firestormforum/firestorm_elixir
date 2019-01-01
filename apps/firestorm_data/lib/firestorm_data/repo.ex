defmodule FirestormData.Repo do
  use Ecto.Repo, otp_app: :firestorm_data, adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 20
end
