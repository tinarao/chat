defmodule Chat.Repo.Migrations.AddChatIdToEncrMsg do
  use Ecto.Migration

  def change do
    alter table(:encrypted_message) do
      add :secret_chat_id, references(:secret_chats, on_delete: :delete_all), null: false
    end
  end
end
