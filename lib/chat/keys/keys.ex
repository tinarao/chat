defmodule Chat.Keys.Key do
  use Ecto.Schema
  import Ecto.Changeset

  schema "keys" do
    field :key_data, :string
    field :is_active, :boolean, default: false

    belongs_to :user, Chat.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(key, attrs) do
    key
    |> cast(attrs, [:key_data, :is_active, :user_id])
    |> validate_required([:key_data, :is_active, :user_id])
  end
end
