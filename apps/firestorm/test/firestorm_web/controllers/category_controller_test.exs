defmodule FirestormWeb.CategoryControllerTest do
  use FirestormWeb.ConnCase
  import Firestorm.Factory

  alias Firestorm.FirestormAdmin
  alias FirestormWeb.Router.Helpers, as: Routes

  @create_attrs %{
    inserted_at: ~N[2010-04-17 14:00:00],
    slug: "some slug",
    title: "some title",
    updated_at: ~N[2010-04-17 14:00:00]
  }
  @update_attrs %{
    inserted_at: ~N[2011-05-18 15:01:01],
    slug: "some updated slug",
    title: "some updated title",
    updated_at: ~N[2011-05-18 15:01:01]
  }
  @invalid_attrs %{inserted_at: nil, slug: nil, title: nil, updated_at: nil}

  describe "index" do
    test "lists all categories", %{conn: conn} do
      conn = get(conn, Routes.category_path(conn, :index))
      assert html_response(conn, 200) =~ "Categories"
    end
  end

  describe "new category" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.category_path(conn, :new))
      assert html_response(conn, 200) =~ "New Category"
    end
  end

  describe "create category" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.category_path(conn, :create), category: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.category_path(conn, :show, id)

      conn = get(conn, Routes.category_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Category Details"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.category_path(conn, :create), category: @invalid_attrs
      assert html_response(conn, 200) =~ "New Category"
    end
  end

  describe "edit category" do
    setup [:create_category]

    test "renders form for editing chosen category", %{conn: conn, category: category} do
      conn = get(conn, Routes.category_path(conn, :edit, category))
      assert html_response(conn, 200) =~ "Edit Category"
    end
  end

  describe "update category" do
    setup [:create_category]

    test "redirects when data is valid", %{conn: conn, category: category} do
      conn = put conn, Routes.category_path(conn, :update, category), category: @update_attrs
      assert redirected_to(conn) == Routes.category_path(conn, :show, category)

      conn = get(conn, Routes.category_path(conn, :show, category))
      assert html_response(conn, 200) =~ "some-updated-title"
    end

    test "renders errors when data is invalid", %{conn: conn, category: category} do
      conn = put conn, Routes.category_path(conn, :update, category), category: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Category"
    end
  end

  describe "delete category" do
    setup [:create_category]

    test "deletes chosen category", %{conn: conn, category: category} do
      conn = delete(conn, Routes.category_path(conn, :delete, category))
      assert redirected_to(conn) == Routes.category_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.category_path(conn, :show, category))
      end
    end
  end

  defp create_category(_) do
    category = insert(:category)
    {:ok, category: category}
  end
end
