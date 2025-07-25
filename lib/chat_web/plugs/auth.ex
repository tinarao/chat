defmodule ChatWeb.Plugs.Auth do
  import Plug.Conn
  alias Chat.Tokens

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> jwt] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- Tokens.verify(jwt),
         user <- Chat.Accounts.get_user(claims["user_id"]) do
      assign(conn, :current_user, user)
    else
      _ -> send_resp(conn, 401, "Unauthorized") |> halt()
    end
  end
end
