defmodule ChatWeb.APIRoomsController do
  alias Ecto.UUID
  use ChatWeb, :controller

  def show(conn, %{"topic" => topic}) do
    case Chat.Chats.get_by_topic(topic) do
      nil ->
        conn |> put_status(404) |> json(%{error: "room does not exist"})

      room ->
        conn |> put_status(200) |> json(%{topic: room.topic, name: room.name})
    end
  end

  def create(conn, %{"name" => name}) do
    user = conn.assigns.current_user

    topic = "room:" <> UUID.generate()

    room = %{
      name: name,
      topic: topic
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
