defmodule FirestormData.Repo.Migrations.CreateThreads do
  use Ecto.Migration

  def change do
    create table(:firestorm_threads_threads, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:title, :string)

      add(
        :category_id,
        references(:firestorm_categories_categories, type: :binary_id, on_delete: :delete_all)
      )

      timestamps()
    end

    create(index(:firestorm_threads_threads, [:category_id]))
  end
end
