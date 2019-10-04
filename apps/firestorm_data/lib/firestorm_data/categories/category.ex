defmodule FirestormData.Categories.Category.TitleSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug
end

defmodule FirestormData.Categories.Category do
  @moduledoc """
  Schema for forum categories.
  """

  use FirestormData.Data, :model

  alias FirestormData.{
    Categories.Category,
    Threads.Thread
  }

  alias FirestormData.Categories.Category.TitleSlug

  @type t :: %Category{
          id: String.t(),
          title: String.t(),
          slug: String.t(),
          threads: [Thread.t()] | %Ecto.Association.NotLoaded{},
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }
  schema "firestorm_categories_categories" do
    field(:title, :string)
    field(:slug, TitleSlug.Type)
    has_many(:threads, Thread)

    timestamps()
  end

  def changeset(%__MODULE__{} = category, attrs \\ %{}) do
    category
    |> cast(attrs, [:title])
    |> TitleSlug.maybe_generate_slug()
    |> TitleSlug.unique_constraint()
    |> validate_required([:title])
  end
end
