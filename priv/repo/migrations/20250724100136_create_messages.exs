defmodule Chat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :text
      add :user_id, references(:users, on_delete: :nilify_all), null: true
      add :room_id, references(:rooms, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:user_id])
    create index(:messages, [:room_id])
  end
end
