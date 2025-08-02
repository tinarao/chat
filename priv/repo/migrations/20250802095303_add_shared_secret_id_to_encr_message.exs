defmodule Chat.Repo.Migrations.AddSharedSecretIdToEncrMessage do
  use Ecto.Migration

  def change do
    alter table(:encrypted_message) do
      # nullable. if no ss_id -> no history at ALL
      add :shared_secret_id, :string
    end
  end
end
