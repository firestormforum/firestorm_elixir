defmodule FirestormData.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:firestorm_categories_categories, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:title, :string)

      timestamps()
    end
  end
end
