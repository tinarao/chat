defmodule Chat.Repo.Migrations.CreateSecretChats do
  use Ecto.Migration

  def change do
    create table(:secret_chats) do
      add :first_user_id, :integer
      add :second_user_id, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
