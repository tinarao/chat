defmodule ChatWeb.SecretChatChannel do
  use ChatWeb, :channel

  alias Chat.EncryptedMessages
  alias Chat.Tokens

  @impl true
  def join("secret:" <> chat_id, %{"token" => token}, socket) do
    case Tokens.extract_user(token) do
      {:ok, user} ->
        messages = EncryptedMessages.get_by_chat_id(chat_id)
        {:ok, %{messages: messages}, socket}

      {:error, _} ->
        {:error, %{error: "вы не авторизованы"}, socket}
    end
  end

  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (secret_chat:lobby).
  @impl true
  def handle_in("new_message", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end
end
