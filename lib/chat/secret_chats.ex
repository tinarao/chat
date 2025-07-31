defmodule Chat.SecretChats do
  import Ecto.Query, warn: false

  alias Chat.SecretChats.SecretChat
  alias Chat.Repo

  def create(attrs \\ %{}) do
    %SecretChat{}
    |> SecretChat.changeset(attrs)
    |> Repo.insert()
  end

  def get_my(user_id) do
    SecretChat
    |> where(first_user_id: ^user_id)
    |> or_where(second_user_id: ^user_id)
    |> preload([:first_user, :second_user])
    |> Repo.all()
  end

  def get_by_id(id), do: Repo.get(SecretChat, id)

  # returns only one
  def get_by_user_ids(id1, id2) do
    SecretChat
    |> where(first_user_id: ^id1, second_user_id: ^id2)
    |> or_where(first_user_id: ^id2, second_user_id: ^id1)
    |> preload([:first_user, :second_user])
    |> limit(1)
    |> Repo.one()
  end
end
