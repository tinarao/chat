defmodule Chat.Chats do
  @moduledoc """
  The Chats context.
  """

  import Ecto.Query, warn: false
  alias Chat.Repo

  alias Chat.Chats.Room

  def list_rooms do
    Repo.all(Room)
  end

  def get_by_topic(topic) do
    Repo.get_by(Room, topic: topic)
  end

  def get_room!(id), do: Repo.get!(Room, id)

  def get_room(id) do
    Repo.get(Room, id)
  end

  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  def get_my_rooms(user_id) do
    Room
    |> join(:inner, [r], u in assoc(r, :users))
    |> where([_r, u], u.id == ^user_id)
    |> Repo.all()
  end

  def ensure_lobby_exists() do
    case(Repo.get_by(Room, topic: "room:lobby")) do
      nil ->
        IO.puts("Lobby did not exist. Creating.")

        %Room{}
        |> Room.changeset(%{
          name: "Lobby",
          topic: "room:lobby",
          creator_id: 0,
          allow_anonyms: true
        })
        |> Repo.insert()

      room ->
        IO.puts("Lobby exists in database.")
        {:ok, room}
    end
  end

  def add_user_to_room(room_id, user_id) do
    exists =
      Repo.exists?(
        from ur in "user_rooms", where: ur.user_id == ^user_id and ur.room_id == ^room_id
      )

    if exists do
      {:error, :already_exists}
    else
      now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

      case Repo.insert_all(
             "user_rooms",
             [
               %{
                 user_id: user_id,
                 room_id: room_id,
                 inserted_at: now,
                 updated_at: now
               }
             ]
           ) do
        {1, _} -> {:ok}
        _ -> {:error, :insert_failed}
      end
    end
  end

  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  def change_room(%Room{} = room, attrs \\ %{}) do
    Room.changeset(room, attrs)
  end
end
