defmodule ChatWeb.APISecretChatsController do
  alias Chat.Accounts
  alias Chat.SecretChats
  use ChatWeb, :controller

  def create(conn, %{"with_username" => with_username}) do
    user = conn.assigns.current_user
    contact = Accounts.get_by_username(with_username)

    if is_nil(contact) do
      conn |> put_status(404) |> json(%{error: "пользователь не найден"})
    end

    existing = SecretChats.get_by_user_ids(user.id, contact.id)

    if !is_nil(existing) do
      conn |> put_status(400) |> json(%{error: "чат уже существует"})
    end

    case SecretChats.create(%{
           first_user_id: user.id,
           second_user_id: contact.id
         }) do
      nil ->
        conn
        |> put_status(400)
        |> json(%{
          error: "пользователь не найден"
        })

      _chat ->
        conn
        |> put_status(201)
        |> json(%{result: "created"})
    end
  end

  def get_my(conn, _params) do
    user = conn.assigns.current_user
    chats = SecretChats.get_my(user.id) |> Enum.map(&SecretChats.to_map/1)

    conn |> put_status(200) |> json(%{chats: chats})
  end
end
