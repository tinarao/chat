defmodule ChatWeb.UserController do
  use ChatWeb, :controller
  alias Chat.Accounts
  alias Chat.Accounts.User

  def index(conn, _params) do
    users = Accounts.list_users()
    json(conn, users)
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    json(conn, user)
  end
end
