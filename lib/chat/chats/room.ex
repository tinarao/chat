defmodule Chat.Chats.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    has_many :messages, Chat.Messages.Message
    many_to_many :users, Chat.Accounts.User, join_through: "user_rooms"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [])
  end
end
