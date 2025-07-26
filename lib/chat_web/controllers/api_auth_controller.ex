defmodule ChatWeb.APIAuthController do
  use ChatWeb, :controller

  def options(conn, _params) do
    conn
    |> send_resp(200, "")
  end

  def me(conn, _params) do
    user = conn.assigns.current_user

    conn
    |> put_status(200)
    |> json(%{
      user: %{
        username: user.username,
        id: user.id
      }
    })
  end

  def signup(conn, %{"email" => email, "password" => password, "username" => username}) do
    is_unique =
      Chat.Accounts.is_unique(email, username)

    if is_unique do
      conn
      |> put_status(400)
      |> json(%{
        error: "пользователь с такими данными уже зарегистрирован"
      })
    end

    case Chat.Accounts.create_user(%{
           email: email,
           password: password,
           username: username
         }) do
      {:ok, user} ->
        conn
        |> put_status(201)
        |> json(%{
          id: user.id,
          email: email
        })

      {:error, reason} ->
        conn
        |> put_status(422)
        |> json(%{error: reason})
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Chat.Auth.login(email, password) do
      {:ok, token} ->
        conn
        |> put_resp_cookie("tt", token,
          http_only: false,
          secure: false,
          same_site: "lax",
          max_age: 7 * 24 * 60 * 60
        )
        |> put_status(201)
        |> json(%{
          user: %{
            result: "success"
          }
        })

      {:error, reason} ->
        conn |> put_status(400) |> json(%{error: reason})
    end
  end
end
