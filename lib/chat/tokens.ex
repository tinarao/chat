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
    # Добавляем кастомные claims
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

  def verify(token) do
    verify_and_validate(token)
  end
end
