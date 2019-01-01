defmodule FirestormData.Categories do
  @moduledoc """
  Threads exist within categories.
  """

  alias FirestormData.{
    Repo,
    Categories.Category
  }

  @type index_params :: %{
          optional(:pagination) => %{
            optional(:per_page) => non_neg_integer(),
            optional(:page) => non_neg_integer()
          }
        }
  @type index :: %{
          entries: [Category.t()],
          page: non_neg_integer(),
          per_page: non_neg_integer(),
          total_pages: non_neg_integer(),
          total_entries: non_neg_integer()
        }

  @doc """
  List categories
  """
  @spec list_categories(index_params()) :: index()
  def list_categories(options) do
    pagination = Map.get(options, :pagination, %{page: 1, per_page: 20})
    page = Map.get(pagination, :page, 1)
    per_page = Map.get(pagination, :per_page, 20)

    Repo.paginate(Category, page: page, page_size: per_page)
  end

  @doc """
  Finds a category by attributes

  ## Examples

      iex> find_category(%{title: "Elixir"})
      {:ok, %Category{}}

      iex> find_category(%{field: bad_value})
      {:error, :no_such_category}

  """
  @spec find_category(map()) :: {:ok, Category.t()} | {:error, :no_such_category}
  def find_category(attrs \\ %{}) do
    Category
    |> Repo.get_by(attrs)
    |> case do
      nil -> {:error, :no_such_category}
      category -> {:ok, category}
    end
  end

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{title: "Elixir"})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_category(map()) :: {:ok, Category.t()} | {:error, Ecto.Changeset.t()}
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a single category by id.

  ## Examples

      iex> get_category("123")
      {:ok, %Category{}}

      iex> get_category!("456")
      {:error, :no_such_category}

  """
  @spec get_category(String.t()) :: {:ok, Category.t()} | {:error, :no_such_category}
  def get_category(id) do
    case Repo.get(Category, id) do
      nil -> {:error, :no_such_category}
      category -> {:ok, category}
    end
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_category(Category.t(), map()) :: {:ok, Category.t()} | {:error, Ecto.Changeset.t()}
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  @spec delete_category(Category.t()) :: {:ok, Category.t()} | {:error, Ecto.Changeset.t()}
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end
end
