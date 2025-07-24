defmodule Chat.Chats.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :topic, :string
    field :name, :string
    has_many :messages, Chat.Messages.Message
    many_to_many :users, Chat.Accounts.User, join_through: "user_rooms"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :topic])
    |> validate_required([:name, :topic])
    |> unique_constraint(:topic)
  end
end
