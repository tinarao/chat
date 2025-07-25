defmodule ChatWeb.AuthErrorHanler do
  use ChatWeb, :controller

  def call(conn, _err) do
    conn
    |> put_status(401)
    |> json(%{error: "Unauthorized"})
  end
end
