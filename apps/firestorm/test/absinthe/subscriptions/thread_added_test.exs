defmodule Firestorm.Absinthe.Subscriptions.ThreadAddedTest do
  use FirestormWeb.SubscriptionCase

  alias FirestormData.Categories

  @category_title "Some category"
  @title "Some thread"
  @body "First post"

  setup do
    {:ok, category} = Categories.create_category(%{title: @category_title})
    {:ok, category: category}
  end

  test "threadAdded subscription", %{
    socket: socket,
    category: category,
    user: user
  } do
    subscription_query = """
      subscription {
        threadAdded(categoryId: "#{category.id}") {
          id
          title
          posts {
            body
            user {
              id
            }
          }
        }
      }
    """

    ref = push_doc(socket, subscription_query)

    assert_reply(ref, :ok, %{subscriptionId: _subscription_id})

    create_thread_mutation = """
      mutation f {
        createThread(categoryId: "#{category.id}", title: "#{@title}", body: "#{@body}") {
          title
          id
        }
      }
    """

    ref =
      push_doc(
        socket,
        create_thread_mutation
      )

    assert_reply(ref, :ok, reply)
    data = reply.data["createThread"]
    assert data["title"] == @title

    assert_push("subscription:data", push)
    data = push.result.data["threadAdded"]
    assert data["title"] == @title
    assert [first_post] = data["posts"]
    assert first_post["body"] == @body
    assert first_post["user"]["id"] == user.id
  end
end
