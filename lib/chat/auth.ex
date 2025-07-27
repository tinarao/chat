defmodule Chat.Auth do
  def login(email, password) do
    with %Chat.Accounts.User{} = user <- Chat.Accounts.get_by_email(email),
         true <- Chat.Accounts.verify_password(user, password),
         {:ok, token, _} <- Chat.Tokens.generate(user) do
      {:ok, token}
    else
      {:error, :secret_not_found} ->
        IO.inspect("Ключи не заданы. Какого хуя? Не знаю.")
        {:error, "ошибка сервера"}

      nil ->
        {:error, "Пользователь не найден"}

      false ->
        {:error, "Неверный логин и/или пароль"}

      {:error, reason} ->
        {:error, reason}

      unexpected ->
        IO.inspect(unexpected, label: "unexpected in auth.login")
        {:error, "ошибка сервера"}
    end
  end
end
