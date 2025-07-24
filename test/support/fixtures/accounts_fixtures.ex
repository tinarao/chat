defmodule Chat.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chat.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        avatar_url: "some avatar_url",
        bio: "some bio",
        username: "some username"
      })
      |> Chat.Accounts.create_user()

    user
  end
end
