defmodule Chat.ChatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chat.Chats` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{

      })
      |> Chat.Chats.create_room()

    room
  end
end
