defmodule Chat.Repo.Migrations.AddPasswordToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :email, :string, null: false
      add :password_hash, :string, null: false
    end

    create unique_index(:users, [:email])
  end
end
