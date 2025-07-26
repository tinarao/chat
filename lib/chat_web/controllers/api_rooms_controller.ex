defmodule ChatWeb.APIRoomsController do
  use ChatWeb, :controller
  import Slugy

  def create(conn, %{"name" => name}) do
    user = conn.assigns.current_user

    # hash, instead of slug. cyrrilic thing is pain in the ass 
    topic = slugify(name)

    room = %{
      name: name,
      topic: topic
    }

    case Chat.Chats.create_room(room) do
      {:ok, room} ->
        conn
        |> put_status(201)
        |> json(%{
          topic: topic
        })

      {:error, reason} ->
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
