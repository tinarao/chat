defmodule Chat.EncryptedMessages do
  import Ecto.Query, warn: false
  alias Chat.EncryptedMessages.EncryptedMessage
  alias Chat.Repo

  def get_by_chat_id(id) do
    EncryptedMessage
    |> where(secret_chat_id: ^id)
    |> preload([:sender, :recipient])
    |> Repo.all()
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
