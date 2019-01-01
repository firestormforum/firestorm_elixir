defmodule FirestormWeb.Schema.PaginationTypes do
  use Absinthe.Schema.Notation

  @desc "Pagination options"
  input_object :pagination do
    field(:per_page, non_null(:integer))
    field(:page, non_null(:integer))
  end
end
