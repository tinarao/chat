defmodule ChatWeb.APIKeysController do
  use ChatWeb, :controller

  alias Chat.Keys

  def create(conn, %{"key_data" => key_data}) do
    user = conn.assigns.current_user

    case Keys.create_key(%{
           key_data: key_data,
           is_active: true,
           user_id: user.id
         }) do
      {:ok, _keys} ->
        conn
        |> put_status(201)
        |> json(%{message: "ключи успешно сохранены"})

      {:error, reason} ->
        IO.inspect(reason)

        conn
        |> put_status(400)
        |> json(%{error: "не удалось сохранить ключи."})
    end
  end

  def create(conn, _params) do
    conn
    |> put_status(400)
    |> json(%{
      error: "incorrect request"
    })
  end

  def get_by_user(conn, %{"user_id" => user_id}) do
    case Keys.get_by_user_id(user_id) do
      nil ->
        conn
        |> put_status(404)
        |> json(%{
          message: "ключ не найден"
        })

      key ->
        conn
        |> put_status(200)
        |> json(%{
          key: key.key_data,
          is_active: key.is_active
        })
    end
  end
end
