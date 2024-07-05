defmodule RmmWeb.UserSessionController do
  use RmmWeb, :controller

  alias Rmm.EstruturasDeDados.Entidades
  alias RmmWeb.UserAuth

  def new(conn, _params) do
    render(conn, :new, error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Entidades.get_user_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, "Bem vindo de volta!")
      |> UserAuth.log_in_user(user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, :new, error_message: "Email ou Senha inválida")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Log out efetuado com sucesso.")
    |> UserAuth.log_out_user()
  end
end
