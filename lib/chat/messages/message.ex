defmodule Chat.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string

    belongs_to :user, Chat.Accounts.User
    belongs_to :room, Chat.Chats.Room
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :user_id, :room_id])
    |> validate_required([:content, :user_id, :room_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:room)
  end
end
