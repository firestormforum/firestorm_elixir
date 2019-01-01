defmodule FirestormWeb.PageController do
  use FirestormWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
