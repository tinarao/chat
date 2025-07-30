defmodule Chat.SecretChat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "secret_chats" do
    field :first_user_id, :integer
    field :second_user_id, :integer

    has_many :messages, Chat.EncryptedMessages.EncryptedMessage

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(secret_chat, attrs) do
    secret_chat
    |> cast(attrs, [:first_user_id, :second_user_id])
    |> validate_required([:first_user_id, :second_user_id])
  end
end
