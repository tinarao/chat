defmodule Chat.Keys do
  import Ecto.Query, warn: false

  alias Chat.Keys.Key
  alias Chat.Repo

  def create_key(attrs \\ %{}) do
    %Key{}
    |> Key.changeset(attrs)
    |> Repo.insert()
  end

  def get_by_user_id(user_id) do
    Key
    |> where(user_id: ^user_id)
    |> Repo.one()
  end
end
