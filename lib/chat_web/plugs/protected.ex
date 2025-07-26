defmodule ChatWeb.Plugs.Protected do
  import Plug.Conn
  alias Chat.Tokens

  def init(opts), do: opts

  def call(conn, _opts) do
    with token when is_binary(token) <- get_cookies(conn)["tt"],
         {:ok, user} <- Tokens.extract_user(token) do
      assign(conn, :current_user, user)
    else
      _ ->
        send_resp(conn, 401, "unauthorized") |> halt()
    end
  end
end
