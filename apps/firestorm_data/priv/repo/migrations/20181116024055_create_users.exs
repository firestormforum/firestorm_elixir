defmodule FirestormData.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:firestorm_users_users, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:username, :string)
      add(:email, :string)
      add(:name, :string)
      add(:password_hash, :string)
      add(:api_token, :string)

      timestamps()
    end

    create(unique_index(:firestorm_users_users, [:username]))
  end
end
