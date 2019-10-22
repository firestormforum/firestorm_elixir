defmodule FirestormData.Seed do
  @moduledoc """
  Some seed data for getting the application into a usable state from an empty database.

  Presently this is used primarily for development purposes - a production-specific seeder could be
  created to replace it if needed.
  """

  alias FirestormData.{
    Users,
    Categories,
    Threads,
    Posts
  }

  @spec call() :: :ok
  def call do
    IO.puts("")

    IO.puts("== Creating Users ==")

    {:ok, adam} =
      Users.create_user(%{
        name: "Adam Dill",
        username: "adam",
        email: "adam@smoothterminal.com",
        admin: true,
        password: "password"
      })

    {:ok, josh} =
      Users.create_user(%{
        name: "Josh Adams",
        username: "josh",
        email: "josh@smoothterminal.com",
        admin: true,
        password: "password"
      })

    {:ok, franzejr} =
      Users.create_user(%{
        name: "Franzé",
        username: "franzejr",
        email: "franzejr@smoothterminal.com",
        admin: true,
        password: "password"
      })

    IO.puts("== Creating Categories ==")
    {:ok, programming_lang} = Categories.create_category(%{title: "Programming Languages"})
    {:ok, off_topic} = Categories.create_category(%{title: "Off Topic"})
    {:ok, soft_eng} = Categories.create_category(%{title: "Software Engineering"})

    IO.puts("== Creating Threads ==")

    {:ok, otp_cool} =
      Threads.create_thread(programming_lang, franzejr, %{
        title: "OTP is cool",
        body: "I really love otp"
      })

    {:ok, rv} =
      Threads.create_thread(off_topic, josh, %{
        title: "I lived in an RV for some months",
        body: "That was cool. I could work and enjoy the life."
      })

    IO.puts("== Creating Posts ==")
    Posts.create_post(otp_cool, franzejr, %{body: "Don't you think?"})
    Posts.create_post(otp_cool, josh, %{body: "I totally agree."})
    Posts.create_post(otp_cool, adam, %{body: "Howwdy! I agree too!"})

    Posts.create_post(rv, josh, %{body: "Ask me questions."})

    Posts.create_post(rv, franzejr, %{
      body: "How could you work inside the RV? How was your routine?"
    })
  end
end
