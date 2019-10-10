defmodule FirestormData.Repo.Migrations.AddAdminToUsers do
  use Ecto.Migration

  def change do
    alter table(:firestorm_users_users) do
      add(:admin, :boolean, default: false)
    end
  end
end
