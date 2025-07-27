defmodule ChatWeb.RoomChannel do
  use Phoenix.Channel
  alias Chat.Tokens

  defp find_user(params) do
    with token when is_binary(token) <- params["token"],
         {:ok, user} <- Tokens.extract_user(token) do
      user
    else
      _ -> nil
    end
  end

  def join("room:lobby", params, socket) do
    Chat.Chats.ensure_lobby_exists()

    {:ok, socket}
  end

  def join(topic, params, socket) do
    with room <- Chat.Chats.get_by_topic(topic),
         true <- room.allow_anonyms do
      {:ok, socket}
    else
      nil ->
        {:error,
         %{
           error: %{
             title: "комната \"" <> topic <> "\" не найдена"
           }
         }}

      false ->
        {:error,
         %{
           error: %{
             title: "комната \"" <> topic <> "\" не найдена"
           }
         }}
    end
  end

  def handle_in("new_message", %{"user" => user, "content" => content}, socket) do
    case socket.topic do
      "room:lobby" ->
        handle_lobby_message(%{"user" => user, "content" => content}, socket)

      _other ->
        handle_other_topic_message(%{"user" => user, "content" => content}, socket)
    end
  end

  defp handle_lobby_message(%{"user" => user, "content" => content}, socket) do
    broadcast_msg(socket, user, content)
    {:reply, :ok, socket}
  end

  defp handle_other_topic_message(%{"user" => user, "content" => content}, socket) do
    case Chat.Chats.get_by_topic(socket.topic) do
      nil ->
        {:reply, :error, "topic not found"}

      _topic ->
        broadcast_msg(socket, user, content)
        {:reply, :ok, socket}
    end
  end

  defp broadcast_msg(socket, %{"username" => username, "id" => id}, content) do
    broadcast(socket, "new_message", %{
      user: %{
        username: username,
        id: id
      },
      content: content,
      createdAt: DateTime.utc_now()
    })
  end
end
