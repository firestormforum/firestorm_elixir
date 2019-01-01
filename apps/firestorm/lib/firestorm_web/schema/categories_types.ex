defmodule FirestormWeb.Schema.CategoriesTypes do
  use Absinthe.Schema.Notation
  alias FirestormWeb.Resolvers

  object :paginated_categories do
    field(:page, non_null(:integer)) do
      resolve(fn pagination, _, _ -> {:ok, pagination.page_number} end)
    end

    field(:per_page, non_null(:integer)) do
      resolve(fn pagination, _, _ -> {:ok, pagination.page_size} end)
    end

    field(:total_pages, non_null(:integer))
    field(:total_entries, non_null(:integer))
    field(:entries, non_null(list_of(non_null(:category))))
  end

  object :category do
    field(:id, non_null(:id))
    field(:title, non_null(:string))

    field :threads, non_null(list_of(non_null(:thread))) do
      resolve(&Resolvers.Threads.list_threads/3)
    end

    field(:inserted_at, non_null(:datetime))
    field(:updated_at, non_null(:datetime))
  end
end
