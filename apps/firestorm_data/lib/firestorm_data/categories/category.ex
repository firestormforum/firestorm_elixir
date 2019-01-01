defmodule FirestormData.Categories.Category do
  @moduledoc """
  Schema for forum categories.
  """

  use FirestormData.Data, :model

  alias FirestormData.{
    Categories.Category,
    Threads.Thread
  }

  @type t :: %Category{
          id: String.t(),
          title: String.t(),
          threads: [Thread.t()] | %Ecto.Association.NotLoaded{},
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }
  schema "firestorm_categories_categories" do
    field(:title, :string)
    has_many(:threads, Thread)

    timestamps()
  end

  def changeset(%__MODULE__{} = category, attrs \\ %{}) do
    category
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
