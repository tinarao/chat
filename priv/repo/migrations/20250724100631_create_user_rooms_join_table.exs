defmodule Chat.Repo.Migrations.CreateUserRoomsJoinTable do
  use Ecto.Migration

  def change do
    create table(:user_rooms) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :room_id, references(:rooms, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:user_rooms, [:user_id, :room_id])
  end
end
