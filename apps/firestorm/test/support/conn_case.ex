defmodule FirestormWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate
  import Firestorm.Factory
  import Plug.Test
  import Plug.Conn

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import FirestormWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint FirestormWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(FirestormData.Repo, ownership_timeout: 30000)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(FirestormData.Repo, {:shared, self()})
    end

    conn = Phoenix.ConnTest.build_conn()

    %{user: user, conn: conn} =
      if tags[:logged_in_admin] do
        user = insert(:user, admin: true)

        conn =
          conn
          |> init_test_session(%{})
          |> put_session(:current_user_id, user.id)

        %{user: user, conn: conn}
      else
        %{user: nil, conn: conn}
      end

    {:ok, conn: conn, user: user}
  end
end
