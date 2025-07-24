defmodule ChatWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> room_id, _message, socket) do
    {:ok, socket}
  end

  def handle_in("new_message", %{"user" => user, "content" => content}, socket) do
    case socket.topic do
      "room:lobby" ->
        handle_lobby_message(user, content, socket)

      topic ->
        handle_other_topic_message(user, content, socket)
    end
  end

  defp handle_lobby_message(user, content, socket) do
    broadcast(socket, "new_message", %{
      user: %{
        username: user
      },
      content: content
    })

    {:reply, :ok, socket}
  end

  defp handle_other_topic_message(user, content, socket) do
    # check room
    # check user
    # save msg
    # etc
    broadcast(socket, "new_message", %{
      user: %{
        username: user
      },
      content: content
    })

    {:reply, :ok, socket}
  end
end
