defmodule Chat.SecretChats.SecretChat do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Jason.Encoder,
    only: [:id, :first_user, :second_user, :inserted_at, :updated_at]
  }

  schema "secret_chats" do
    belongs_to :first_user, Chat.Accounts.User
    belongs_to :second_user, Chat.Accounts.User

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
