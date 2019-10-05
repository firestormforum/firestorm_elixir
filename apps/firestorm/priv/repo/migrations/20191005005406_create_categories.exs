defmodule Firestorm.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :title, :string
      add :slug, :string
      add :inserted_at, :naive_datetime
      add :updated_at, :naive_datetime

      timestamps()
    end

  end
end
