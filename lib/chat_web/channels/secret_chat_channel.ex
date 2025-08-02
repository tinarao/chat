defmodule ChatWeb.SecretChatChannel do
  use ChatWeb, :channel

  alias Chat.EncryptedMessages
  alias Chat.Tokens

  @impl true
  def join("secret:" <> chat_id, %{"token" => token}, socket) do
    case Tokens.extract_user(token) do
      {:ok, _user} ->
        messages = EncryptedMessages.get_by_chat_id(chat_id)
        {:ok, %{messages: messages}, socket}

      {:error, _} ->
        {:error, %{error: "вы не авторизованы"}, socket}
    end
  end

  @impl true
  def handle_in("new_message", %{"content" => content, "token" => token}, socket) do
    case Tokens.extract_user(token) do
      {:ok, user} ->
        "secret:" <> chat_id = socket.topic
        save_message(content, user.id, chat_id)

        broadcast(socket, "new_message", content)
        {:noreply, socket}

      {:error, _} ->
        {:error, %{error: "вы не авторизованы"}, socket}
    end
  end

  defp save_message(content, sender_id, chat_id) do
    attrs = %{
      cipher_text: content["cipherText"],
      iv: content["iv"],
      status: "delivered",
      shared_secret_id: content["shared_secret_id"],
      sender_id: sender_id,
      recipient_id: content["recipientId"],
      secret_chat_id: chat_id
    }

    EncryptedMessages.create(attrs)
  end
end
