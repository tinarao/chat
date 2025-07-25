defmodule ChatWeb.APIAuthController do
  use ChatWeb, :controller

  def options(conn, _params) do
    conn
    |> send_resp(200, "")
  end

  def me(conn, _params) do
    user = conn.assigns.current_user
    json(conn, %{email: user.email, username: user.username})
  end

  def signup(conn, %{"email" => email, "password" => password, "username" => username}) do
    is_unique =
      Chat.Accounts.is_unique(email, username)

    IO.inspect(is_unique)

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
        conn |> put_status(201) |> json(%{token: token})

      {:error, reason} ->
        conn |> put_status(400) |> json(%{error: reason})
    end
  end
end
