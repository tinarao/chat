defmodule Chat.Repo.Migrations.AddTopicToRooms do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :topic, :string, null: false
      add :name, :string
    end

    create unique_index(:rooms, [:topic])
  end
end
