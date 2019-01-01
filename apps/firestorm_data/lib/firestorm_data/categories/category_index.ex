defmodule FirestormData.Categories.CategoryIndex do
  @moduledoc false

  @type params :: %{
          optional(:pagination) => %{
            optional(:per_page) => non_neg_integer(),
            optional(:page) => non_neg_integer()
          }
        }
end
