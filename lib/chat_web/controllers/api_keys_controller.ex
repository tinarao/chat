defmodule ChatWeb.APIKeysController do
  use ChatWeb, :controller

  alias Chat.Tokens
  alias Chat.Keys

  def create(conn, %{"key_data" => key_data}) do
    user = conn.assigns.current_user

    attrs = %{
      key_data: key_data,
      is_active: true,
      user_id: user.id
    }

    case Keys.add_new_key(attrs) do
      {:ok} ->
        conn |> put_status(201) |> json(%{result: "ok"})

      {:error, reason} ->
        IO.inspect(reason)
        conn |> put_status(500) |> json(%{error: "failed to add new key"})
    end
  end

  def create(conn, _params) do
    conn
    |> put_status(400)
    |> json(%{
      error: "incorrect request"
    })
  end

  def get_by_user(conn, %{"username" => username}) do
    case Keys.get_by_user_username(username) do
      nil ->
        conn
        |> put_status(404)
        |> json(%{
          error: "ключ не найден"
        })

      key ->
        conn
        |> put_status(200)
        |> json(%{
          key: %{
            key: key.key_data,
            is_active: key.is_active
          }
        })
    end
  end

  def get_by_user(conn, %{"user_id" => user_id}) do
    case Keys.get_by_user_id(user_id) do
      nil ->
        conn
        |> put_status(404)
        |> json(%{
          error: "ключ не найден"
        })

      key ->
        conn
        |> put_status(200)
        |> json(%{
          key: %{
            key: key.key_data,
            is_active: key.is_active
          }
        })
    end
  end

  def get_by_user(conn, _params) do
    user = conn.assigns.current_user

    case Keys.get_by_user_id(user.id) do
      nil ->
        conn
        |> put_status(404)
        |> json(%{
          error: "ключ не найден"
        })

      key ->
        conn
        |> put_status(200)
        |> json(%{
          key: %{
            key: key.key_data,
            is_active: key.is_active
          }
        })
    end
  end
end
