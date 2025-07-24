defmodule ChatWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    {:ok, socket}
  end

  def join("room:" <> room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
