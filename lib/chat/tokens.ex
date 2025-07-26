defmodule Chat.Tokens do
  use Joken.Config

  @impl true
  def token_config do
    default_claims(
      iss: "chat_api",
      aud: "client",

      # month. will change
      exp: 2_628_288,
      iat: System.os_time()
    )
    |> add_claim("user_id", nil, &validate_user/1)
  end

  defp validate_user(user_id) do
    case Chat.Accounts.get_user(user_id) do
      nil -> false
      _ -> true
    end
  end

  def generate(user) do
    extra_claims = %{
      "user_id" => user.id,
      "username" => user.username
    }

    generate_and_sign(extra_claims)
  end

  @spec extract_user(binary()) :: {:error, <<_::96>>} | {:ok, any()}
  def extract_user(token) do
    with {:ok, %{"user_id" => user_id}} <- verify_and_validate(token),
         true <- validate_user(user_id),
         user <- Chat.Accounts.get_user(user_id) do
      {:ok, user}
    else
      _ ->
        {:error, "unauthorized"}
    end
  end
end
