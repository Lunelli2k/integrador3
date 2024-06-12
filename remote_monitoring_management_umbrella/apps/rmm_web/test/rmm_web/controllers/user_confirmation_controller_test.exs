defmodule RmmWeb.UserConfirmationControllerTest do
  use RmmWeb.ConnCase, async: true

  alias Rmm.EstruturasDeDados.Entidades
  alias Rmm.Repo
  import Rmm.EstruturasDeDados.EntidadesFixtures

  setup do
    %{user: user_fixture()}
  end

  describe "GET /user/confirm" do
    test "renders the resend confirmation page", %{conn: conn} do
      conn = get(conn, ~p"/user/confirm")
      response = html_response(conn, 200)
      assert response =~ "Resend confirmation instructions"
    end
  end

  describe "POST /user/confirm" do
    @tag :capture_log
    test "sends a new confirmation token", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/user/confirm", %{
          "user" => %{"email" => user.email}
        })

      assert redirected_to(conn) == ~p"/"

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.get_by!(Entidades.UserToken, user_id: user.id).context == "confirm"
    end

    test "does not send confirmation token if User is confirmed", %{conn: conn, user: user} do
      Repo.update!(Entidades.User.confirm_changeset(user))

      conn =
        post(conn, ~p"/user/confirm", %{
          "user" => %{"email" => user.email}
        })

      assert redirected_to(conn) == ~p"/"

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      refute Repo.get_by(Entidades.UserToken, user_id: user.id)
    end

    test "does not send confirmation token if email is invalid", %{conn: conn} do
      conn =
        post(conn, ~p"/user/confirm", %{
          "user" => %{"email" => "unknown@example.com"}
        })

      assert redirected_to(conn) == ~p"/"

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.all(Entidades.UserToken) == []
    end
  end

  describe "GET /user/confirm/:token" do
    test "renders the confirmation page", %{conn: conn} do
      token_path = ~p"/user/confirm/some-token"
      conn = get(conn, token_path)
      response = html_response(conn, 200)
      assert response =~ "Confirm account"

      assert response =~ "action=\"#{token_path}\""
    end
  end

  describe "POST /user/confirm/:token" do
    test "confirms the given token once", %{conn: conn, user: user} do
      token =
        extract_user_token(fn url ->
          Entidades.deliver_user_confirmation_instructions(user, url)
        end)

      conn = post(conn, ~p"/user/confirm/#{token}")
      assert redirected_to(conn) == ~p"/"

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "User confirmed successfully"

      assert Entidades.get_user!(user.id).confirmed_at
      refute get_session(conn, :user_token)
      assert Repo.all(Entidades.UserToken) == []

      # When not logged in
      conn = post(conn, ~p"/user/confirm/#{token}")
      assert redirected_to(conn) == ~p"/"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "User confirmation link is invalid or it has expired"

      # When logged in
      conn =
        build_conn()
        |> log_in_user(user)
        |> post(~p"/user/confirm/#{token}")

      assert redirected_to(conn) == ~p"/"
      refute Phoenix.Flash.get(conn.assigns.flash, :error)
    end

    test "does not confirm email with invalid token", %{conn: conn, user: user} do
      conn = post(conn, ~p"/user/confirm/oops")
      assert redirected_to(conn) == ~p"/"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~
               "User confirmation link is invalid or it has expired"

      refute Entidades.get_user!(user.id).confirmed_at
    end
  end
end
