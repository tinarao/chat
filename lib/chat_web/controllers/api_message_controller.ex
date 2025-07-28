defmodule ChatWeb.APIMessagesController do
  alias Chat.Messages
  alias Chat.Chats
  use ChatWeb, :controller

  def get_by_room(conn, %{"topic" => topic}) do
    room = Chats.get_by_topic(topic)

    messages =
      Messages.get_messages_by_room(:topic, room.id)
      |> Enum.map(&Chat.Messages.serialize_message/1)

    IO.inspect(messages)

    conn
    |> put_status(200)
    |> json(%{message: messages})
  end
end
