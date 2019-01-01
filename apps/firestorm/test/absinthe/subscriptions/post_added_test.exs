defmodule Firestorm.Absinthe.Subscriptions.PostAddedTest do
  use FirestormWeb.SubscriptionCase

  alias FirestormData.{
    Categories,
    Threads
  }

  @category_title "Some category"
  @thread_title "Some thread"
  @first_post_body "First post"
  @body "Second post"

  setup %{user: user} do
    {:ok, category} = Categories.create_category(%{title: @category_title})
    {:ok, thread} = Threads.create_thread(category, user, %{title: @thread_title, body: @body})
    {:ok, category: category, thread: thread}
  end

  test "threadAdded subscription", %{
    socket: socket,
    thread: thread,
    user: user
  } do
    subscription_query = """
      subscription {
        postAdded(threadId: "#{thread.id}") {
          body
          user {
            id
          }
        }
      }
    """

    ref = push_doc(socket, subscription_query)

    assert_reply(ref, :ok, %{subscriptionId: _subscription_id})

    create_post_mutation = """
      mutation f {
        createPost(threadId: "#{thread.id}", body: "#{@body}") {
          id
          body
        }
      }
    """

    ref =
      push_doc(
        socket,
        create_post_mutation
      )

    assert_reply(ref, :ok, reply)
    data = reply.data["createPost"]
    assert data["body"] == @body

    assert_push("subscription:data", push)
    data = push.result.data["postAdded"]
    assert data["body"] == @body
    assert data["user"]["id"] == user.id
  end
end
