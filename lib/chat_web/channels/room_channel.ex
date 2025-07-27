defmodule ChatWeb.RoomChannel do
  use Phoenix.Channel
  alias Chat.Chats
  alias Chat.Tokens

  def join("room:lobby", _params, socket) do
    Chats.ensure_lobby_exists()
    {:ok, socket}
  end

  def join(topic, %{"token" => token}, socket) do
    case get_room_and_user(topic, token) do
      {:ok, room, user} ->
        Chats.add_user_to_room(room.id, user.id)
        {:ok, socket}

      {:error, reason} ->
        {:error, %{error: %{title: reason}}}
    end
  end

  def join(topic, _params, socket) do
    case Chats.get_by_topic(topic) do
      nil ->
        {:error, %{error: %{title: "комната \"#{topic}\" не найдена"}}}

      room ->
        if room.allow_anonyms do
          {:ok, socket}
        else
          {:error, %{error: %{title: "комната \"#{topic}\" требует авторизации"}}}
        end
    end
  end

  def handle_in("new_message", %{"token" => token, "content" => content}, socket) do
    user = extract_user_from_token(token)

    case validate_room_access(socket.topic, user) do
      :ok ->
        broadcast_message(socket, user, content)
        {:reply, :ok, socket}

      :error ->
        {:reply, :error, "Room not found"}
    end
  end

  # Private functions

  defp get_room_and_user(topic, token) do
    with room when not is_nil(room) <- Chats.get_by_topic(topic),
         {:ok, user} <- Tokens.extract_user(token) do
      {:ok, room, user}
    else
      nil -> {:error, "комната \"#{topic}\" не найдена"}
      {:error, _} -> {:error, "неверный токен авторизации"}
    end
  end

  defp extract_user_from_token(token) do
    case Tokens.extract_user(token) do
      {:ok, user} -> user
      {:error, _} -> %{username: "Anonymous", id: 0}
    end
  end

  defp validate_room_access("room:lobby", _user), do: :ok

  defp validate_room_access(topic, user) do
    case Chats.get_by_topic(topic) do
      nil ->
        :error

      room ->
        if !room.allow_anonyms && user.id == 0 do
          :error
        else
          :ok
        end
    end
  end

  defp broadcast_message(socket, user, content) do
    broadcast(socket, "new_message", %{
      user: %{
        username: user.username,
        id: user.id
      },
      content: content,
      createdAt: DateTime.utc_now()
    })
  end
end
