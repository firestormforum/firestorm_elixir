defmodule FirestormWeb.ThreadControllerTest do
  use FirestormWeb.ConnCase

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

  # def fixture(:thread) do
  #   {:ok, thread} = FirestormAdmin.create_thread(@create_attrs)
  #   thread
  # end

  # describe "index" do
  #   test "lists all threads", %{conn: conn} do
  #     conn = get(conn, Routes.thread_path(conn, :index))
  #     assert html_response(conn, 200) =~ "Threads"
  #   end
  # end

  # describe "new thread" do
  #   test "renders form", %{conn: conn} do
  #     conn = get(conn, Routes.thread_path(conn, :new))
  #     assert html_response(conn, 200) =~ "New Thread"
  #   end
  # end

  # describe "create thread" do
  #   test "redirects to show when data is valid", %{conn: conn} do
  #     conn = post conn, Routes.thread_path(conn, :create), thread: @create_attrs

  #     assert %{id: id} = redirected_params(conn)
  #     assert redirected_to(conn) == Routes.thread_path(conn, :show, id)

  #     conn = get(conn, Routes.thread_path(conn, :show, id))
  #     assert html_response(conn, 200) =~ "Thread Details"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post conn, Routes.thread_path(conn, :create), thread: @invalid_attrs
  #     assert html_response(conn, 200) =~ "New Thread"
  #   end
  # end

  # describe "edit thread" do
  #   setup [:create_thread]

  #   test "renders form for editing chosen thread", %{conn: conn, thread: thread} do
  #     conn = get(conn, Routes.thread_path(conn, :edit, thread))
  #     assert html_response(conn, 200) =~ "Edit Thread"
  #   end
  # end

  # describe "update thread" do
  #   setup [:create_thread]

  #   test "redirects when data is valid", %{conn: conn, thread: thread} do
  #     conn = put conn, Routes.thread_path(conn, :update, thread), thread: @update_attrs
  #     assert redirected_to(conn) == Routes.thread_path(conn, :show, thread)

  #     conn = get(conn, Routes.thread_path(conn, :show, thread))
  #     assert html_response(conn, 200) =~ "some updated slug"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, thread: thread} do
  #     conn = put conn, Routes.thread_path(conn, :update, thread), thread: @invalid_attrs
  #     assert html_response(conn, 200) =~ "Edit Thread"
  #   end
  # end

  # describe "delete thread" do
  #   setup [:create_thread]

  #   test "deletes chosen thread", %{conn: conn, thread: thread} do
  #     conn = delete(conn, Routes.thread_path(conn, :delete, thread))
  #     assert redirected_to(conn) == Routes.thread_path(conn, :index)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.thread_path(conn, :show, thread))
  #     end
  #   end
  # end

  # defp create_thread(_) do
  #   thread = fixture(:thread)
  #   {:ok, thread: thread}
  # end
end
