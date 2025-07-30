defmodule Chat.Messages do
  import Ecto.Query, warn: false

  alias Chat.Repo
  alias Chat.Messages.Message

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  def get_messages_by_room(:topic, topic) do
    room = Chat.Chats.get_by_topic(topic)

    if is_nil(room) do
      []
    end

    get_messages_by_room(:id, room.id)
  end

  def get_messages_by_room(:id, room_id) do
    Message
    |> where(room_id: ^room_id)
    |> order_by(asc: :inserted_at)
    |> preload(:user)
    |> Repo.all()
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  def serialize_message(%{user: user} = message) when not is_nil(user) do
    message
    |> Map.from_struct()
    |> Map.drop([:__meta__, :room])
    |> Map.put(:user, %{id: message.user.id, username: message.user.username})
  end

  def serialize_message(message) do
    message
    |> Map.from_struct()
    |> Map.drop([:__meta__, :room])
    |> Map.put(:user, %{id: 0, username: "Anonymous"})
  end

  def serialize_messages_list(messages) do
    messages |> Enum.map(&serialize_message/1)
  end
end
