defmodule Chat.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :content, :string

    belongs_to :user, YourApp.Accounts.User
    belongs_to :room, YourApp.Chat.Room
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
