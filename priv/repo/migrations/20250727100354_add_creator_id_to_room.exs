defmodule Chat.Repo.Migrations.AddCreatorIdToRoom do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      add :creator_id, :integer, null: false
      add :allow_anonyms, :boolean, default: true
    end
  end
end
