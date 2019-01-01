defmodule Firestorm.Absinthe.Subscriptions.CategoryAddedTest do
  use FirestormWeb.SubscriptionCase

  alias FirestormData.{
    Users
  }

  @title "Some category"

  test "categoryAdded subscription", %{socket: socket} do
    subscription_query = """
      subscription {
        categoryAdded {
          id
          title
        }
      }
    """

    ref = push_doc(socket, subscription_query)

    assert_reply(ref, :ok, %{subscriptionId: _subscription_id})

    create_category_mutation = """
      mutation f {
        createCategory(title: "#{@title}") {
          title
          id
        }
      }
    """

    ref =
      push_doc(
        socket,
        create_category_mutation
      )

    assert_reply(ref, :ok, reply)
    data = reply.data["createCategory"]
    assert data["title"] == @title

    assert_push("subscription:data", push)
    data = push.result.data["categoryAdded"]
    assert data["title"] == @title
  end
end
