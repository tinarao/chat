defmodule ChatWeb.APIMessagesController do
  alias Chat.Messages
  use ChatWeb, :controller

  def get_by_room(conn, %{"topic" => topic}) do
    messages =
      Messages.get_messages_by_room(:topic, topic)
      |> Enum.map(&Chat.Messages.serialize_message/1)

    conn
    |> put_status(200)
    |> json(%{message: messages})
  end
end
