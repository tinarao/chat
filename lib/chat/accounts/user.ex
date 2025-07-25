defmodule Chat.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :bio, :string, default: ""
    field :avatar_url, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    has_many :messages, Chat.Messages.Message
    many_to_many :rooms, Chat.Chats.Room, join_through: "user_rooms"

    timestamps(type: :utc_datetime)
  end

  def register_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password])
    |> validate_required([:email, :username, :password])
    |> validate_length(:password, min: 8)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :email, :bio, :avatar_url])
    |> validate_required([:username, :email, :password_hash])
    |> validate_length(:password, min: 8)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  def put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password -> put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
    end
  end
end
