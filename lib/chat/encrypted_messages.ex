defmodule Chat.EncryptedMessages do
  import Ecto.Query, warn: false
  alias Chat.EncryptedMessages.EncryptedMessage
  alias Chat.Repo

  def get_by_chat_id(id) do
    EncryptedMessage
    |> where(secret_chat_id: ^id)
    |> preload([:sender, :recipient, :secret_chat])
    |> Repo.all()
  end

  def create(attrs) do
    %EncryptedMessage{}
    |> EncryptedMessage.changeset(attrs)
    |> Repo.insert()
  end

  def remove_all_my_messages(user_id) do
    EncryptedMessage
    |> where([m], m.sender_id == ^user_id)
    |> or_where([m], m.recipient_id == ^user_id)
    |> Repo.delete_all()
  end

  def to_map(message) do
    %{
      cipher_text: message.cipher_text,
      iv: message.iv,
      status: message.status,
      sender: %{
        id: message.sender.id,
        username: message.sender.username
      }
    }
  end
end
