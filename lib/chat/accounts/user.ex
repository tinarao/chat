defmodule Chat.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :bio, :string
    field :avatar_url, :string

    has_many :messages, Chat.Messages.Message
    many_to_many :rooms, Chat.Chats.Room, join_through: "user_rooms"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :bio, :avatar_url])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end
end
