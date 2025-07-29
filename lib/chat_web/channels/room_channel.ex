defmodule ChatWeb.RoomChannel do
  use Phoenix.Channel
  alias ChatWeb.Channels.Common
  alias Chat.Chats
  alias Chat.Tokens

  def join("room:lobby", _params, socket) do
    Chats.ensure_lobby_exists()

    {:ok, %{messages: Common.load_messages("room:lobby")}, socket}
  end

  # authorized join
  def join(topic, %{"token" => token}, socket) do
    case get_room_and_user(topic, token) do
      {:ok, room, user} ->
        Chats.add_user_to_room(room.id, user.id)

        {:ok, %{messages: Common.load_messages(topic)}, socket}

      {:error, reason} ->
        {:error, %{error: %{title: reason}}}
    end
  end

  # anonymous join
  def join(topic, _params, socket) do
    with room <- Chats.get_by_topic(topic),
         true <- room.allow_anonyms do
      {:ok, %{messages: Common.load_messages(topic)}, socket}
    else
      nil ->
        {:error, %{error: %{title: "комната " <> topic <> " не найдена"}}}

      false ->
        {:error, %{error: %{title: "комната " <> topic <> " требует авторизации"}}}
    end
  end

  def handle_in("new_message", %{"token" => token, "content" => content}, socket) do
    user = extract_user_from_token(token)

    case validate_room_access(socket.topic, user) do
      :ok ->
        case Common.save_message(socket.topic, content, user) do
          {:ok, message} ->
            Common.broadcast_message(socket, user, message)
            {:reply, :ok, socket}

          {:error, _reason} ->
            {:reply, {:error, %{reason: "failed to save message"}}, socket}
        end

      :error ->
        {:reply, {:error, %{reason: "Room not found"}}, socket}
    end
  end

  def handle_in("new_message", %{"content" => content}, socket) do
    user = %{username: "Anonymous", id: 0}

    case validate_room_access(socket.topic, user) do
      :ok ->
        case Common.save_message(socket.topic, content, user) do
          {:ok, message} ->
            Common.broadcast_message(socket, user, message)
            {:reply, :ok, socket}

          {:error, _reason} ->
            {:reply, {:error, %{reason: "failed to save message"}}, socket}
        end

      :error ->
        {:reply, {:error, %{reason: "Room not found"}}, socket}
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
      {:ok, user} ->
        user

      {:error, _} ->
        %{username: "Anonymous", id: 0}
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
end
