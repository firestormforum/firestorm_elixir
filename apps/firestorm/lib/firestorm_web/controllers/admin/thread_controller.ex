defmodule FirestormWeb.Admin.ThreadController do
  use FirestormWeb, :controller

  alias Firestorm.FirestormAdmin
  alias FirestormData.Threads.Thread

  plug(:put_layout, {FirestormWeb.LayoutView, "torch.html"})

  def index(conn, params) do
    case FirestormAdmin.paginate_threads(params) do
      {:ok, assigns} ->
        render(conn, "index.html", assigns)

      error ->
        conn
        |> put_flash(:error, "There was an error rendering Threads. #{inspect(error)}")
        |> redirect(to: Routes.thread_path(conn, :index))
    end
  end

  def new(conn, _params) do
    changeset = FirestormAdmin.change_thread(%Thread{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"thread" => thread_params}) do
    case FirestormAdmin.create_thread(thread_params) do
      {:ok, thread} ->
        conn
        |> put_flash(:info, "Thread created successfully.")
        |> redirect(to: Routes.thread_path(conn, :show, thread))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    thread = FirestormAdmin.get_thread!(id)
    render(conn, "show.html", thread: thread)
  end

  def edit(conn, %{"id" => id}) do
    thread = FirestormAdmin.get_thread!(id)
    changeset = FirestormAdmin.change_thread(thread)
    render(conn, "edit.html", thread: thread, changeset: changeset)
  end

  def update(conn, %{"id" => id, "thread" => thread_params}) do
    thread = FirestormAdmin.get_thread!(id)

    case FirestormAdmin.update_thread(thread, thread_params) do
      {:ok, thread} ->
        conn
        |> put_flash(:info, "Thread updated successfully.")
        |> redirect(to: Routes.thread_path(conn, :show, thread))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", thread: thread, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    thread = FirestormAdmin.get_thread!(id)
    {:ok, _thread} = FirestormAdmin.delete_thread(thread)

    conn
    |> put_flash(:info, "Thread deleted successfully.")
    |> redirect(to: Routes.thread_path(conn, :index))
  end
end
