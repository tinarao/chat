defmodule ChatWeb.Channels.Common do
  use Phoenix.Channel
  alias Chat.Messages
  alias Chat.Chats

  def broadcast_message(socket, user, message) do
    broadcast(socket, "new_message", %{
      user: %{
        username: user.username,
        id: user.id
      },
      content: message.content,
      inserted_at: message.inserted_at,
      updated_at: message.updated_at
    })
  end

  def save_message(topic, message, user) when user.id != 0 do
    case Chats.get_by_topic(topic) do
      nil ->
        {:error, "chat not found"}

      room ->
        changeset = %{
          content: message,
          room_id: room.id,
          user_id: user.id
        }

        Messages.create_message(changeset)
    end
  end

  def save_message(topic, message, _user) do
    case Chats.get_by_topic(topic) do
      nil ->
        {:error, "chat not found"}

      room ->
        changeset = %{
          content: message,
          room_id: room.id
        }

        Messages.create_message(changeset)
    end
  end

  def load_messages(topic) do
    Messages.get_messages_by_room(:topic, topic)
    |> Messages.serialize_messages_list()
  end
end
