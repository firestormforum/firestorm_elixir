defmodule Firestorm.Factory do
  use ExMachina.Ecto, repo: FirestormData.Repo

  alias FirestormData.{
    Categories.Category,
    Threads.Thread
  }

  def category_factory do
    %Category{
      title: Faker.Lorem.word(),
      threads: []
    }
  end

  def thread_factory do
    %Thread{
      title: Faker.Lorem.word(),
      category: build(:category)
    }
  end
end
