defmodule FirestormWeb.Admin.CategoryController do
  use FirestormWeb, :controller

  alias Firestorm.FirestormAdmin
  alias FirestormData.Categories.Category

  plug(:put_layout, {FirestormWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    case FirestormAdmin.paginate_categories(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(:error, "There was an error rendering Categories. #{inspect(error)}")
        |> redirect(to: Routes.category_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = FirestormAdmin.change_category(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    case FirestormAdmin.create_category(category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: Routes.category_path(conn, :show, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = FirestormAdmin.get_category!(id)
    render(conn, "show.html", category: category)
  end

  def edit(conn, %{"id" => id}) do
    category = FirestormAdmin.get_category!(id)
    changeset = FirestormAdmin.change_category(category)
    render(conn, "edit.html", category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = FirestormAdmin.get_category!(id)

    case FirestormAdmin.update_category(category, category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: Routes.category_path(conn, :show, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = FirestormAdmin.get_category!(id)
    {:ok, _category} = FirestormAdmin.delete_category(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: Routes.category_path(conn, :index))
  end
end
