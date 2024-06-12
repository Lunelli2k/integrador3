defmodule RmmWeb.UserRegistrationController do
  use RmmWeb, :controller

  alias Rmm.EstruturasDeDados.Entidades
  alias Rmm.EstruturasDeDados.Entidades.User
  alias RmmWeb.UserAuth

  def new(conn, _params) do
    changeset = Entidades.change_user_registration(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Entidades.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Entidades.deliver_user_confirmation_instructions(
            user,
            &url(~p"/user/confirm/#{&1}")
          )

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end
end
