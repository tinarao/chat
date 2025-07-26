defmodule Chat.Accounts do
  @moduledoc """
  The Accounts context.
  """
  import Ecto.Query, warn: false
  alias Chat.Repo
  alias Chat.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a signle user. Do not raise. 
  """
  def get_user(id), do: Repo.get(User, id)

  def get_by_email(email) do
    Repo.get_by(Chat.Accounts.User, email: email)
  end

  def is_unique(email, username) do
    from(u in Chat.Accounts.User,
      where: u.email == ^email,
      or_where: u.username == ^username,
      select: count(u.id) > 0
    )
    |> Repo.exists?()
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_user(map()) :: {:ok, Chat.Accounts.User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(attrs \\ %{}) do
    user_data =
      %Chat.Accounts.User{}
      |> User.register_changeset(attrs)

    IO.inspect(user_data)

    # Ecto.Changeset.cast()

    case Repo.insert(user_data) do
      {:ok, user} -> {:ok, user}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def verify_password(%User{password_hash: hash}, password) when is_binary(password) do
    Argon2.verify_pass(password, hash)
  end
end
