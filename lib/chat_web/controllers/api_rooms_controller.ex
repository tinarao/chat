defmodule ChatWeb.APIRoomsController do
  alias Chat.Chats
  alias Ecto.UUID
  use ChatWeb, :controller

  def show(conn, %{"topic" => topic}) do
    case Chat.Chats.get_by_topic(topic) do
      nil ->
        conn |> put_status(404) |> json(%{error: "room does not exist"})

      room ->
        conn
        |> put_status(200)
        |> json(%{
          id: room.id,
          topic: room.topic,
          name: room.name,
          creatorId: room.creator_id,
          allowAnonyms: room.allow_anonyms
        })
    end
  end

  def switch_allow_anonyms(conn, %{"room_id" => room_id, "allow_anonyms" => allow_anonyms}) do
    current_user = conn.assigns.current_user

    with room <- Chat.Chats.get_room(room_id),
         true <- room.creator_id == current_user.id,
         {:ok, room} <- Chat.Chats.update_room(room, %{allow_anonyms: allow_anonyms}) do
      conn
      |> put_status(201)
      |> json(%{
        new_value: room.allow_anonyms
      })
    else
      nil ->
        conn
        |> put_status(404)
        |> json(%{
          error: "комната не найдена"
        })

      false ->
        conn
        |> put_status(403)
        |> json(%{
          error: "нет прав"
        })

      {:error, reason} ->
        conn
        |> put_status(500)
        |> json(%{
          error: reason
        })
    end
  end

  def get_my_rooms(conn, _params) do
    user = conn.assigns.current_user
    chats = Chats.get_my_rooms(user.id)

    serialized_chats =
      Enum.map(chats, fn room ->
        %{
          id: room.id,
          topic: room.topic,
          name: room.name,
          creatorId: room.creator_id,
          allowAnonyms: room.allow_anonyms
        }
      end)

    conn
    |> put_status(200)
    |> json(%{chats: serialized_chats})
  end

  def create(conn, %{"name" => name}) do
    user = conn.assigns.current_user

    topic = "room:" <> UUID.generate()

    room = %{
      name: name,
      topic: topic,
      creator_id: user.id
    }

    case Chat.Chats.create_room(room) do
      {:ok, _room} ->
        conn
        |> put_status(201)
        |> json(%{
          topic: topic
        })

      {:error, _reason} ->
        conn
        |> put_status(400)
        |> json(%{
          error: "выберите другое название."
        })
    end

    conn
    |> put_status(201)
    |> json(%{
      current_user_email: user.email
    })
  end
end
