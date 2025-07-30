defmodule Chat.Repo.Migrations.CreateEncryptedMessage do
  use Ecto.Migration

  def change do
    create table(:encrypted_message) do
      add :cipher_text, :string
      add :iv, :string
      add :status, :string
      add :sender_id, references(:users, on_delete: :delete_all), null: false
      add :recipient_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
