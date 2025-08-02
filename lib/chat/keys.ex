defmodule Chat.Keys do
  import Ecto.Query, warn: false

  alias Chat.Accounts
  alias Chat.Keys.Key
  alias Chat.Repo

  def get_by_user_id(user_id) do
    Key
    |> where([k], k.user_id == ^user_id and k.is_active == ^true)
    |> Repo.one()
  end

  def get_by_user_username(username) do
    case Accounts.get_by_username(username) do
      nil ->
        nil

      user ->
        get_by_user_id(user.id)
    end
  end

  def add_new_key(attrs) do
    with {:ok, key} <- create_key(attrs),
         {:ok, _} <- expire_all_keys(attrs.user_id, key.id) do
      {:ok}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp create_key(attrs) do
    %Key{}
    |> Key.changeset(attrs)
    |> Repo.insert()
  end

  defp expire_all_keys(user_id, except_key_id) do
    Repo.transaction(fn ->
      Key
      |> where([k], k.user_id == ^user_id and k.id != ^except_key_id)
      |> update([k], set: [is_active: false])
      |> Repo.update_all([])
    end)
  rescue
    error ->
      {:error, error}
  end
end
