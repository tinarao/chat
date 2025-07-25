defmodule ChatWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", %{"token" => token}, socket) do
    Chat.Chats.ensure_lobby_exists()
    {:ok, socket}
  end

  def join("room:" <> topic, _message, socket) do
    case Chat.Chats.get_by_topic(topic) do
      nil ->
        {:error,
         %{
           error: %{
             title: "комната \"" <> topic <> "\" не найдена"
           }
         }}

      _room ->
        {:ok, socket}
    end
  end

  def handle_in("new_message", %{"user" => user, "content" => content}, socket) do
    case socket.topic do
      "room:lobby" ->
        handle_lobby_message(user, content, socket)

      _other ->
        handle_other_topic_message(user, content, socket)
    end
  end

  defp handle_lobby_message(user, content, socket) do
    broadcast(socket, "new_message", %{
      user: %{
        username: user
      },
      content: content,
      created_at: DateTime.utc_now()
    })

    # chat = Chat.Chats.Room.c

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
      content: content,
      created_at: DateTime.utc_now()
    })

    {:reply, :ok, socket}
  end
end
