defmodule Chat.EncryptedMessages.EncryptedMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "encrypted_message" do
    field :cipher_text, :string
    field :iv, :string
    field :status, Ecto.Enum, values: [:pending, :delivered]

    belongs_to :sender, Chat.Accounts.User
    belongs_to :recipient, Chat.Accounts.User
    belongs_to :secret_chat, Chat.EncryptedMessages.EncryptedMessage

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(encrypted_message, attrs) do
    encrypted_message
    |> cast(attrs, [:cipher_text, :iv, :status, :sender_id, :recipient_id])
    |> validate_required([:cipher_text, :iv, :status, :sender_id, :recipient_id])
  end
end
