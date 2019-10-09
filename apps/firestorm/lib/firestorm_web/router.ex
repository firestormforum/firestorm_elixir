defmodule FirestormWeb.Router do
  use FirestormWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :graphql do
    plug(FirestormWeb.Context)
  end

  scope "/", FirestormWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/graphql" do
    pipe_through(:graphql)

    forward(
      "/",
      Absinthe.Plug.GraphiQL,
      schema: FirestormWeb.Schema,
      socket: FirestormWeb.UserSocket,
      json_codec: Jason
    )
  end

  pipeline :admin do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    # plug(FirestormWeb.Plug.EnsureAdmin)
  end

  scope "/admin", FirestormWeb.Admin do
    pipe_through(:admin)
    resources("/categories", CategoryController)
    resources("/threads", ThreadController)
    resources("/posts", PostController)
    resources("/users", UserController)
  end

  # Other scopes may use custom stacks.
  # scope "/api", FirestormWeb do
  #   pipe_through :api
  # end
end
