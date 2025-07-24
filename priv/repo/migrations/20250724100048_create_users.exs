defmodule Chat.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :bio, :text
      add :avatar_url, :string

      timestamps(type: :utc_datetime)
    end
  end
end
