defmodule Chat.EncryptedMessages.EncryptedMessage do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {
    Jason.Encoder,
    only: [
      :cipher_text,
      :iv,
      :status,
      :sender,
      :recipient,
      # :secret_chat,
      :inserted_at,
      :updated_at
    ]
  }

  schema "encrypted_message" do
    field :cipher_text, :string
    field :iv, :string
    field :status, Ecto.Enum, values: [:pending, :delivered]
    field :shared_secret_id, :string

    belongs_to :sender, Chat.Accounts.User
    belongs_to :recipient, Chat.Accounts.User
    belongs_to :secret_chat, Chat.EncryptedMessages.EncryptedMessage

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(encrypted_message, attrs) do
    encrypted_message
    |> cast(attrs, [
      :cipher_text,
      :iv,
      :status,
      :shared_secret_id,
      :sender_id,
      :recipient_id,
      :secret_chat_id
    ])
    |> validate_required([:cipher_text, :iv, :status, :sender_id, :recipient_id])
  end
end
