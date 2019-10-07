defmodule Firestorm.Factory do
  use ExMachina.Ecto, repo: FirestormData.Repo

  alias FirestormData.{
    Users.User,
    Categories.Category,
    Threads.Thread,
    Posts.Post
  }

  def user_factory do
    %User{
      name: Faker.Name.name(),
      username: Faker.Name.name(),
      email: sequence(:email, &"email-#{&1}@example.com")
    }
  end

  def category_factory do
    %Category{
      title: Faker.Lorem.word()
    }
  end

  def thread_factory do
    %Thread{
      title: Faker.Lorem.word(),
      category: build(:category)
    }
  end

  def post_factory do
    %Post{
      body: Faker.Lorem.sentence()
      # thread: build(:thread),
      # user: build(:user)
    }
  end
end
