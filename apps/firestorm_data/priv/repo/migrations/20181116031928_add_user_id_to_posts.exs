defmodule FirestormData.Repo.Migrations.AddUserIdToPosts do
  use Ecto.Migration

  def change do
    alter table(:firestorm_posts_posts) do
      add(:user_id, references(:firestorm_users_users, type: :binary_id, on_delete: :nilify_all))
    end

    create(index(:firestorm_posts_posts, [:user_id]))
  end
end
