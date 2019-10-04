defmodule FirestormData.Repo.Migrations.AddSlugToThreadsAndCategories do
  use Ecto.Migration

  def change do
    alter table(:firestorm_threads_threads) do
      add(:slug, :string)
    end

    alter table(:firestorm_categories_categories) do
      add(:slug, :string)
    end

    create(index(:firestorm_threads_threads, [:slug]))
    create(index(:firestorm_categories_categories, [:slug]))
  end
end
