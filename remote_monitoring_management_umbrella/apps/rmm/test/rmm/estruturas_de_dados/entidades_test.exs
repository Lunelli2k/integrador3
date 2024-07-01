defmodule Rmm.EstruturasDeDados.EntidadesTest do
  use Rmm.DataCase

  alias Rmm.EstruturasDeDados.Entidades

  import Rmm.EstruturasDeDados.EntidadesFixtures
  alias Rmm.EstruturasDeDados.Entidades.{User, UserToken}

  describe "get_user_by_email/1" do
    test "does not return the user if the email does not exist" do
      refute Entidades.get_user_by_email("unknown@example.com")
    end

    test "returns the user if the email exists" do
      %{id: id} = user = user_fixture()
      assert %User{id: ^id} = Entidades.get_user_by_email(user.email)
    end
  end

  describe "get_user_by_email_and_password/2" do
    test "does not return the user if the email does not exist" do
      refute Entidades.get_user_by_email_and_password("unknown@example.com", "hello world!")
    end

    test "does not return the user if the password is not valid" do
      user = user_fixture()
      refute Entidades.get_user_by_email_and_password(user.email, "invalid")
    end

    test "returns the user if the email and password are valid" do
      %{id: id} = user = user_fixture()

      assert %User{id: ^id} =
               Entidades.get_user_by_email_and_password(user.email, valid_user_password())
    end
  end

  describe "get_user!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Entidades.get_user!(-1)
      end
    end

    test "returns the user with the given id" do
      %{id: id} = user = user_fixture()
      assert %User{id: ^id} = Entidades.get_user!(user.id)
    end
  end

  describe "register_user/1" do
    test "requires email and password to be set" do
      {:error, changeset} = Entidades.register_user(%{})

      assert %{
               password: ["can't be blank"],
               email: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates email and password when given" do
      {:error, changeset} = Entidades.register_user(%{email: "not valid", password: "not valid"})

      assert %{
               email: ["must have the @ sign and no spaces"],
               password: ["should be at least 12 character(s)"]
             } = errors_on(changeset)
    end

    test "validates maximum values for email and password for security" do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Entidades.register_user(%{email: too_long, password: too_long})
      assert "should be at most 160 character(s)" in errors_on(changeset).email
      assert "should be at most 72 character(s)" in errors_on(changeset).password
    end

    test "validates email uniqueness" do
      %{email: email} = user_fixture()
      {:error, changeset} = Entidades.register_user(%{email: email})
      assert "has already been taken" in errors_on(changeset).email

      # Now try with the upper cased email too, to check that email case is ignored.
      {:error, changeset} = Entidades.register_user(%{email: String.upcase(email)})
      assert "has already been taken" in errors_on(changeset).email
    end

    test "registers user with a hashed password" do
      email = unique_user_email()
      {:ok, user} = Entidades.register_user(valid_user_attributes(email: email))
      assert user.email == email
      assert is_binary(user.hashed_password)
      assert is_nil(user.confirmed_at)
      assert is_nil(user.password)
    end
  end

  describe "change_user_registration/2" do
    test "returns a changeset" do
      assert %Ecto.Changeset{} = changeset = Entidades.change_user_registration(%User{})
      assert changeset.required == [:password, :email]
    end

    test "allows fields to be set" do
      email = unique_user_email()
      password = valid_user_password()

      changeset =
        Entidades.change_user_registration(
          %User{},
          valid_user_attributes(email: email, password: password)
        )

      assert changeset.valid?
      assert get_change(changeset, :email) == email
      assert get_change(changeset, :password) == password
      assert is_nil(get_change(changeset, :hashed_password))
    end
  end

  describe "change_user_email/2" do
    test "returns a user changeset" do
      assert %Ecto.Changeset{} = changeset = Entidades.change_user_email(%User{})
      assert changeset.required == [:email]
    end
  end

  describe "apply_user_email/3" do
    setup do
      %{user: user_fixture()}
    end

    test "requires email to change", %{user: user} do
      {:error, changeset} = Entidades.apply_user_email(user, valid_user_password(), %{})
      assert %{email: ["did not change"]} = errors_on(changeset)
    end

    test "validates email", %{user: user} do
      {:error, changeset} =
        Entidades.apply_user_email(user, valid_user_password(), %{email: "not valid"})

      assert %{email: ["must have the @ sign and no spaces"]} = errors_on(changeset)
    end

    test "validates maximum value for email for security", %{user: user} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Entidades.apply_user_email(user, valid_user_password(), %{email: too_long})

      assert "should be at most 160 character(s)" in errors_on(changeset).email
    end

    test "validates email uniqueness", %{user: user} do
      %{email: email} = user_fixture()
      password = valid_user_password()

      {:error, changeset} = Entidades.apply_user_email(user, password, %{email: email})

      assert "has already been taken" in errors_on(changeset).email
    end

    test "validates current password", %{user: user} do
      {:error, changeset} =
        Entidades.apply_user_email(user, "invalid", %{email: unique_user_email()})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "applies the email without persisting it", %{user: user} do
      email = unique_user_email()
      {:ok, user} = Entidades.apply_user_email(user, valid_user_password(), %{email: email})
      assert user.email == email
      assert Entidades.get_user!(user.id).email != email
    end
  end

  describe "deliver_user_update_email_instructions/3" do
    setup do
      %{user: user_fixture()}
    end

    test "sends token through notification", %{user: user} do
      token =
        extract_user_token(fn url ->
          Entidades.deliver_user_update_email_instructions(user, "current@example.com", url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert user_token = Repo.get_by(UserToken, token: :crypto.hash(:sha256, token))
      assert user_token.user_id == user.id
      assert user_token.sent_to == user.email
      assert user_token.context == "change:current@example.com"
    end
  end

  describe "update_user_email/2" do
    setup do
      user = user_fixture()
      email = unique_user_email()

      token =
        extract_user_token(fn url ->
          Entidades.deliver_user_update_email_instructions(%{user | email: email}, user.email, url)
        end)

      %{user: user, token: token, email: email}
    end

    test "updates the email with a valid token", %{user: user, token: token, email: email} do
      assert Entidades.update_user_email(user, token) == :ok
      changed_user = Repo.get!(User, user.id)
      assert changed_user.email != user.email
      assert changed_user.email == email
      assert changed_user.confirmed_at
      assert changed_user.confirmed_at != user.confirmed_at
      refute Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not update email with invalid token", %{user: user} do
      assert Entidades.update_user_email(user, "oops") == :error
      assert Repo.get!(User, user.id).email == user.email
      assert Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not update email if user email changed", %{user: user, token: token} do
      assert Entidades.update_user_email(%{user | email: "current@example.com"}, token) == :error
      assert Repo.get!(User, user.id).email == user.email
      assert Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not update email if token expired", %{user: user, token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      assert Entidades.update_user_email(user, token) == :error
      assert Repo.get!(User, user.id).email == user.email
      assert Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "change_user_password/2" do
    test "returns a user changeset" do
      assert %Ecto.Changeset{} = changeset = Entidades.change_user_password(%User{})
      assert changeset.required == [:password]
    end

    test "allows fields to be set" do
      changeset =
        Entidades.change_user_password(%User{}, %{
          "password" => "new valid password"
        })

      assert changeset.valid?
      assert get_change(changeset, :password) == "new valid password"
      assert is_nil(get_change(changeset, :hashed_password))
    end
  end

  describe "update_user_password/3" do
    setup do
      %{user: user_fixture()}
    end

    test "validates password", %{user: user} do
      {:error, changeset} =
        Entidades.update_user_password(user, valid_user_password(), %{
          password: "not valid",
          password_confirmation: "another"
        })

      assert %{
               password: ["should be at least 12 character(s)"],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{user: user} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Entidades.update_user_password(user, valid_user_password(), %{password: too_long})

      assert "should be at most 72 character(s)" in errors_on(changeset).password
    end

    test "validates current password", %{user: user} do
      {:error, changeset} =
        Entidades.update_user_password(user, "invalid", %{password: valid_user_password()})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "updates the password", %{user: user} do
      {:ok, user} =
        Entidades.update_user_password(user, valid_user_password(), %{
          password: "new valid password"
        })

      assert is_nil(user.password)
      assert Entidades.get_user_by_email_and_password(user.email, "new valid password")
    end

    test "deletes all tokens for the given user", %{user: user} do
      _ = Entidades.generate_user_session_token(user)

      {:ok, _} =
        Entidades.update_user_password(user, valid_user_password(), %{
          password: "new valid password"
        })

      refute Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "generate_user_session_token/1" do
    setup do
      %{user: user_fixture()}
    end

    test "generates a token", %{user: user} do
      token = Entidades.generate_user_session_token(user)
      assert user_token = Repo.get_by(UserToken, token: token)
      assert user_token.context == "session"

      # Creating the same token for another user should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%UserToken{
          token: user_token.token,
          user_id: user_fixture().id,
          context: "session"
        })
      end
    end
  end

  describe "get_user_by_session_token/1" do
    setup do
      user = user_fixture()
      token = Entidades.generate_user_session_token(user)
      %{user: user, token: token}
    end

    test "returns user by token", %{user: user, token: token} do
      assert session_user = Entidades.get_user_by_session_token(token)
      assert session_user.id == user.id
    end

    test "does not return user for invalid token" do
      refute Entidades.get_user_by_session_token("oops")
    end

    test "does not return user for expired token", %{token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Entidades.get_user_by_session_token(token)
    end
  end

  describe "delete_user_session_token/1" do
    test "deletes the token" do
      user = user_fixture()
      token = Entidades.generate_user_session_token(user)
      assert Entidades.delete_user_session_token(token) == :ok
      refute Entidades.get_user_by_session_token(token)
    end
  end

  describe "deliver_user_confirmation_instructions/2" do
    setup do
      %{user: user_fixture()}
    end

    test "sends token through notification", %{user: user} do
      token =
        extract_user_token(fn url ->
          Entidades.deliver_user_confirmation_instructions(user, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert user_token = Repo.get_by(UserToken, token: :crypto.hash(:sha256, token))
      assert user_token.user_id == user.id
      assert user_token.sent_to == user.email
      assert user_token.context == "confirm"
    end
  end

  describe "confirm_user/1" do
    setup do
      user = user_fixture()

      token =
        extract_user_token(fn url ->
          Entidades.deliver_user_confirmation_instructions(user, url)
        end)

      %{user: user, token: token}
    end

    test "confirms the email with a valid token", %{user: user, token: token} do
      assert {:ok, confirmed_user} = Entidades.confirm_user(token)
      assert confirmed_user.confirmed_at
      assert confirmed_user.confirmed_at != user.confirmed_at
      assert Repo.get!(User, user.id).confirmed_at
      refute Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not confirm with invalid token", %{user: user} do
      assert Entidades.confirm_user("oops") == :error
      refute Repo.get!(User, user.id).confirmed_at
      assert Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not confirm email if token expired", %{user: user, token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      assert Entidades.confirm_user(token) == :error
      refute Repo.get!(User, user.id).confirmed_at
      assert Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "deliver_user_reset_password_instructions/2" do
    setup do
      %{user: user_fixture()}
    end

    test "sends token through notification", %{user: user} do
      token =
        extract_user_token(fn url ->
          Entidades.deliver_user_reset_password_instructions(user, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert user_token = Repo.get_by(UserToken, token: :crypto.hash(:sha256, token))
      assert user_token.user_id == user.id
      assert user_token.sent_to == user.email
      assert user_token.context == "reset_password"
    end
  end

  describe "get_user_by_reset_password_token/1" do
    setup do
      user = user_fixture()

      token =
        extract_user_token(fn url ->
          Entidades.deliver_user_reset_password_instructions(user, url)
        end)

      %{user: user, token: token}
    end

    test "returns the user with valid token", %{user: %{id: id}, token: token} do
      assert %User{id: ^id} = Entidades.get_user_by_reset_password_token(token)
      assert Repo.get_by(UserToken, user_id: id)
    end

    test "does not return the user with invalid token", %{user: user} do
      refute Entidades.get_user_by_reset_password_token("oops")
      assert Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not return the user if token expired", %{user: user, token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Entidades.get_user_by_reset_password_token(token)
      assert Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "reset_user_password/2" do
    setup do
      %{user: user_fixture()}
    end

    test "validates password", %{user: user} do
      {:error, changeset} =
        Entidades.reset_user_password(user, %{
          password: "not valid",
          password_confirmation: "another"
        })

      assert %{
               password: ["should be at least 12 character(s)"],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{user: user} do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Entidades.reset_user_password(user, %{password: too_long})
      assert "should be at most 72 character(s)" in errors_on(changeset).password
    end

    test "updates the password", %{user: user} do
      {:ok, updated_user} = Entidades.reset_user_password(user, %{password: "new valid password"})
      assert is_nil(updated_user.password)
      assert Entidades.get_user_by_email_and_password(user.email, "new valid password")
    end

    test "deletes all tokens for the given user", %{user: user} do
      _ = Entidades.generate_user_session_token(user)
      {:ok, _} = Entidades.reset_user_password(user, %{password: "new valid password"})
      refute Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "inspect/2 for the User module" do
    test "does not include password" do
      refute inspect(%User{password: "123456"}) =~ "password: \"123456\""
    end
  end

  describe "itens_configuracao" do
    alias Rmm.EstruturasDeDados.Entidades.ItemConfiguracao

    import Rmm.EstruturasDeDados.EntidadesFixtures

    @invalid_attrs %{descricao: nil, fabricante: nil, marca: nil, porcentagem_uso: nil, temperatura: nil, situacao: nil, capacidade_gb: nil, tipo: nil, nucleos: nil, frequencia_mhz: nil, categoria: nil, codigo_integracao: nil}

    test "list_itens_configuracao/0 returns all itens_configuracao" do
      item_configuracao = item_configuracao_fixture()
      assert Entidades.list_itens_configuracao() == [item_configuracao]
    end

    test "get_item_configuracao!/1 returns the item_configuracao with given id" do
      item_configuracao = item_configuracao_fixture()
      assert Entidades.get_item_configuracao!(item_configuracao.id) == item_configuracao
    end

    test "create_item_configuracao/1 with valid data creates a item_configuracao" do
      valid_attrs = %{descricao: "some descricao", fabricante: "some fabricante", marca: "some marca", porcentagem_uso: 120.5, temperatura: 120.5, situacao: :Ativo, capacidade_gb: 42, tipo: "some tipo", nucleos: 42, frequencia_mhz: 42, categoria: :CPU, codigo_integracao: "some codigo_integracao"}

      assert {:ok, %ItemConfiguracao{} = item_configuracao} = Entidades.create_item_configuracao(valid_attrs)
      assert item_configuracao.descricao == "some descricao"
      assert item_configuracao.fabricante == "some fabricante"
      assert item_configuracao.marca == "some marca"
      assert item_configuracao.porcentagem_uso == 120.5
      assert item_configuracao.temperatura == 120.5
      assert item_configuracao.situacao == :Ativo
      assert item_configuracao.capacidade_gb == 42
      assert item_configuracao.tipo == "some tipo"
      assert item_configuracao.nucleos == 42
      assert item_configuracao.frequencia_mhz == 42
      assert item_configuracao.categoria == :CPU
      assert item_configuracao.codigo_integracao == "some codigo_integracao"
    end

    test "create_item_configuracao/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Entidades.create_item_configuracao(@invalid_attrs)
    end

    test "update_item_configuracao/2 with valid data updates the item_configuracao" do
      item_configuracao = item_configuracao_fixture()
      update_attrs = %{descricao: "some updated descricao", fabricante: "some updated fabricante", marca: "some updated marca", porcentagem_uso: 456.7, temperatura: 456.7, situacao: :"1", capacidade_gb: 43, tipo: "some updated tipo", nucleos: 43, frequencia_mhz: 43, categoria: :"Memória Principal", codigo_integracao: "some updated codigo_integracao"}

      assert {:ok, %ItemConfiguracao{} = item_configuracao} = Entidades.update_item_configuracao(item_configuracao, update_attrs)
      assert item_configuracao.descricao == "some updated descricao"
      assert item_configuracao.fabricante == "some updated fabricante"
      assert item_configuracao.marca == "some updated marca"
      assert item_configuracao.porcentagem_uso == 456.7
      assert item_configuracao.temperatura == 456.7
      assert item_configuracao.situacao == :"1"
      assert item_configuracao.capacidade_gb == 43
      assert item_configuracao.tipo == "some updated tipo"
      assert item_configuracao.nucleos == 43
      assert item_configuracao.frequencia_mhz == 43
      assert item_configuracao.categoria == :"Memória Principal"
      assert item_configuracao.codigo_integracao == "some updated codigo_integracao"
    end

    test "update_item_configuracao/2 with invalid data returns error changeset" do
      item_configuracao = item_configuracao_fixture()
      assert {:error, %Ecto.Changeset{}} = Entidades.update_item_configuracao(item_configuracao, @invalid_attrs)
      assert item_configuracao == Entidades.get_item_configuracao!(item_configuracao.id)
    end

    test "delete_item_configuracao/1 deletes the item_configuracao" do
      item_configuracao = item_configuracao_fixture()
      assert {:ok, %ItemConfiguracao{}} = Entidades.delete_item_configuracao(item_configuracao)
      assert_raise Ecto.NoResultsError, fn -> Entidades.get_item_configuracao!(item_configuracao.id) end
    end

    test "change_item_configuracao/1 returns a item_configuracao changeset" do
      item_configuracao = item_configuracao_fixture()
      assert %Ecto.Changeset{} = Entidades.change_item_configuracao(item_configuracao)
    end
  end

  describe "solucoes_contorno" do
    alias Rmm.EstruturasDeDados.Entidades.SolucaoContorno

    import Rmm.EstruturasDeDados.EntidadesFixtures

    @invalid_attrs %{codigo: nil, descricao: nil, situacao: nil, solucao: nil}

    test "list_solucoes_contorno/0 returns all solucoes_contorno" do
      solucao_contorno = solucao_contorno_fixture()
      assert Entidades.list_solucoes_contorno() == [solucao_contorno]
    end

    test "get_solucao_contorno!/1 returns the solucao_contorno with given id" do
      solucao_contorno = solucao_contorno_fixture()
      assert Entidades.get_solucao_contorno!(solucao_contorno.id) == solucao_contorno
    end

    test "create_solucao_contorno/1 with valid data creates a solucao_contorno" do
      valid_attrs = %{codigo: 42, descricao: "some descricao", situacao: :Ativo, solucao: "some solucao"}

      assert {:ok, %SolucaoContorno{} = solucao_contorno} = Entidades.create_solucao_contorno(valid_attrs)
      assert solucao_contorno.codigo == 42
      assert solucao_contorno.descricao == "some descricao"
      assert solucao_contorno.situacao == :Ativo
      assert solucao_contorno.solucao == "some solucao"
    end

    test "create_solucao_contorno/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Entidades.create_solucao_contorno(@invalid_attrs)
    end

    test "update_solucao_contorno/2 with valid data updates the solucao_contorno" do
      solucao_contorno = solucao_contorno_fixture()
      update_attrs = %{codigo: 43, descricao: "some updated descricao", situacao: :Inativo, solucao: "some updated solucao"}

      assert {:ok, %SolucaoContorno{} = solucao_contorno} = Entidades.update_solucao_contorno(solucao_contorno, update_attrs)
      assert solucao_contorno.codigo == 43
      assert solucao_contorno.descricao == "some updated descricao"
      assert solucao_contorno.situacao == :Inativo
      assert solucao_contorno.solucao == "some updated solucao"
    end

    test "update_solucao_contorno/2 with invalid data returns error changeset" do
      solucao_contorno = solucao_contorno_fixture()
      assert {:error, %Ecto.Changeset{}} = Entidades.update_solucao_contorno(solucao_contorno, @invalid_attrs)
      assert solucao_contorno == Entidades.get_solucao_contorno!(solucao_contorno.id)
    end

    test "delete_solucao_contorno/1 deletes the solucao_contorno" do
      solucao_contorno = solucao_contorno_fixture()
      assert {:ok, %SolucaoContorno{}} = Entidades.delete_solucao_contorno(solucao_contorno)
      assert_raise Ecto.NoResultsError, fn -> Entidades.get_solucao_contorno!(solucao_contorno.id) end
    end

    test "change_solucao_contorno/1 returns a solucao_contorno changeset" do
      solucao_contorno = solucao_contorno_fixture()
      assert %Ecto.Changeset{} = Entidades.change_solucao_contorno(solucao_contorno)
    end
  end

  describe "incidentes" do
    alias Rmm.EstruturasDeDados.Entidades.Incidente

    import Rmm.EstruturasDeDados.EntidadesFixtures

    @invalid_attrs %{codigo: nil, descricao: nil, codigo_item_configuracao: nil, codigo_solucao_contorno: nil, situacao: nil, observacao: nil, impacto: nil, prioridade: nil, codigo_regra_evento_criticidade: nil, data_geracao: nil}

    test "list_incidentes/0 returns all incidentes" do
      incidente = incidente_fixture()
      assert Entidades.list_incidentes() == [incidente]
    end

    test "get_incidente!/1 returns the incidente with given id" do
      incidente = incidente_fixture()
      assert Entidades.get_incidente!(incidente.id) == incidente
    end

    test "create_incidente/1 with valid data creates a incidente" do
      valid_attrs = %{codigo: 42, descricao: "some descricao", codigo_item_configuracao: 42, codigo_solucao_contorno: 42, situacao: :Aberto, observacao: "some observacao", impacto: :Nenhum, prioridade: 42, codigo_regra_evento_criticidade: 42, data_geracao: ~U[2024-06-29 15:02:00Z]}

      assert {:ok, %Incidente{} = incidente} = Entidades.create_incidente(valid_attrs)
      assert incidente.codigo == 42
      assert incidente.descricao == "some descricao"
      assert incidente.codigo_item_configuracao == 42
      assert incidente.codigo_solucao_contorno == 42
      assert incidente.situacao == :Aberto
      assert incidente.observacao == "some observacao"
      assert incidente.impacto == :Nenhum
      assert incidente.prioridade == 42
      assert incidente.codigo_regra_evento_criticidade == 42
      assert incidente.data_geracao == ~U[2024-06-29 15:02:00Z]
    end

    test "create_incidente/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Entidades.create_incidente(@invalid_attrs)
    end

    test "update_incidente/2 with valid data updates the incidente" do
      incidente = incidente_fixture()
      update_attrs = %{codigo: 43, descricao: "some updated descricao", codigo_item_configuracao: 43, codigo_solucao_contorno: 43, situacao: :Solucionando, observacao: "some updated observacao", impacto: :Baixo, prioridade: 43, codigo_regra_evento_criticidade: 43, data_geracao: ~U[2024-06-30 15:02:00Z]}

      assert {:ok, %Incidente{} = incidente} = Entidades.update_incidente(incidente, update_attrs)
      assert incidente.codigo == 43
      assert incidente.descricao == "some updated descricao"
      assert incidente.codigo_item_configuracao == 43
      assert incidente.codigo_solucao_contorno == 43
      assert incidente.situacao == :Solucionando
      assert incidente.observacao == "some updated observacao"
      assert incidente.impacto == :Baixo
      assert incidente.prioridade == 43
      assert incidente.codigo_regra_evento_criticidade == 43
      assert incidente.data_geracao == ~U[2024-06-30 15:02:00Z]
    end

    test "update_incidente/2 with invalid data returns error changeset" do
      incidente = incidente_fixture()
      assert {:error, %Ecto.Changeset{}} = Entidades.update_incidente(incidente, @invalid_attrs)
      assert incidente == Entidades.get_incidente!(incidente.id)
    end

    test "delete_incidente/1 deletes the incidente" do
      incidente = incidente_fixture()
      assert {:ok, %Incidente{}} = Entidades.delete_incidente(incidente)
      assert_raise Ecto.NoResultsError, fn -> Entidades.get_incidente!(incidente.id) end
    end

    test "change_incidente/1 returns a incidente changeset" do
      incidente = incidente_fixture()
      assert %Ecto.Changeset{} = Entidades.change_incidente(incidente)
    end
  end

  describe "regras_eventos_criticidade" do
    alias Rmm.EstruturasDeDados.Entidades.RegraEventoCriticidade

    import Rmm.EstruturasDeDados.EntidadesFixtures

    @invalid_attrs %{descricao: nil, tipo_evento_criticidade: nil, condicao: nil, propriedade_verificar: nil, valor_propriedade: nil, prioridade: nil, impacto: nil}

    test "list_regras_eventos_criticidade/0 returns all regras_eventos_criticidade" do
      regra_evento_criticidade = regra_evento_criticidade_fixture()
      assert Entidades.list_regras_eventos_criticidade() == [regra_evento_criticidade]
    end

    test "get_regra_evento_criticidade!/1 returns the regra_evento_criticidade with given id" do
      regra_evento_criticidade = regra_evento_criticidade_fixture()
      assert Entidades.get_regra_evento_criticidade!(regra_evento_criticidade.id) == regra_evento_criticidade
    end

    test "create_regra_evento_criticidade/1 with valid data creates a regra_evento_criticidade" do
      valid_attrs = %{descricao: "some descricao", tipo_evento_criticidade: :Falha, condicao: :Maior, propriedade_verificar: :Temperatura, valor_propriedade: 120.5, prioridade: 42, impacto: :Nenhum}

      assert {:ok, %RegraEventoCriticidade{} = regra_evento_criticidade} = Entidades.create_regra_evento_criticidade(valid_attrs)
      assert regra_evento_criticidade.descricao == "some descricao"
      assert regra_evento_criticidade.tipo_evento_criticidade == :Falha
      assert regra_evento_criticidade.condicao == :Maior
      assert regra_evento_criticidade.propriedade_verificar == :Temperatura
      assert regra_evento_criticidade.valor_propriedade == 120.5
      assert regra_evento_criticidade.prioridade == 42
      assert regra_evento_criticidade.impacto == :Nenhum
    end

    test "create_regra_evento_criticidade/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Entidades.create_regra_evento_criticidade(@invalid_attrs)
    end

    test "update_regra_evento_criticidade/2 with valid data updates the regra_evento_criticidade" do
      regra_evento_criticidade = regra_evento_criticidade_fixture()
      update_attrs = %{descricao: "some updated descricao", tipo_evento_criticidade: :Alerta, condicao: :Igual, propriedade_verificar: :"Porcentagem de Uso", valor_propriedade: 456.7, prioridade: 43, impacto: :Baixo}

      assert {:ok, %RegraEventoCriticidade{} = regra_evento_criticidade} = Entidades.update_regra_evento_criticidade(regra_evento_criticidade, update_attrs)
      assert regra_evento_criticidade.descricao == "some updated descricao"
      assert regra_evento_criticidade.tipo_evento_criticidade == :Alerta
      assert regra_evento_criticidade.condicao == :Igual
      assert regra_evento_criticidade.propriedade_verificar == :"Porcentagem de Uso"
      assert regra_evento_criticidade.valor_propriedade == 456.7
      assert regra_evento_criticidade.prioridade == 43
      assert regra_evento_criticidade.impacto == :Baixo
    end

    test "update_regra_evento_criticidade/2 with invalid data returns error changeset" do
      regra_evento_criticidade = regra_evento_criticidade_fixture()
      assert {:error, %Ecto.Changeset{}} = Entidades.update_regra_evento_criticidade(regra_evento_criticidade, @invalid_attrs)
      assert regra_evento_criticidade == Entidades.get_regra_evento_criticidade!(regra_evento_criticidade.id)
    end

    test "delete_regra_evento_criticidade/1 deletes the regra_evento_criticidade" do
      regra_evento_criticidade = regra_evento_criticidade_fixture()
      assert {:ok, %RegraEventoCriticidade{}} = Entidades.delete_regra_evento_criticidade(regra_evento_criticidade)
      assert_raise Ecto.NoResultsError, fn -> Entidades.get_regra_evento_criticidade!(regra_evento_criticidade.id) end
    end

    test "change_regra_evento_criticidade/1 returns a regra_evento_criticidade changeset" do
      regra_evento_criticidade = regra_evento_criticidade_fixture()
      assert %Ecto.Changeset{} = Entidades.change_regra_evento_criticidade(regra_evento_criticidade)
    end
  end

  describe "regras_eventos_criticidade" do
    alias Rmm.EstruturasDeDados.Entidades.RegraEventoCriticidade

    import Rmm.EstruturasDeDados.EntidadesFixtures

    @invalid_attrs %{descricao: nil, tipo_evento_criticidade: nil, condicao: nil, propriedade_verificar: nil, valor_propriedade: nil, prioridade: nil, impacto: nil, gera_incidente: nil}

    test "list_regras_eventos_criticidade/0 returns all regras_eventos_criticidade" do
      regra_evento_criticidade = regra_evento_criticidade_fixture()
      assert Entidades.list_regras_eventos_criticidade() == [regra_evento_criticidade]
    end

    test "get_regra_evento_criticidade!/1 returns the regra_evento_criticidade with given id" do
      regra_evento_criticidade = regra_evento_criticidade_fixture()
      assert Entidades.get_regra_evento_criticidade!(regra_evento_criticidade.id) == regra_evento_criticidade
    end

    test "create_regra_evento_criticidade/1 with valid data creates a regra_evento_criticidade" do
      valid_attrs = %{descricao: "some descricao", tipo_evento_criticidade: :Falha, condicao: :Maior, propriedade_verificar: :Temperatura, valor_propriedade: 120.5, prioridade: 42, impacto: :Nenhum, gera_incidente: true}

      assert {:ok, %RegraEventoCriticidade{} = regra_evento_criticidade} = Entidades.create_regra_evento_criticidade(valid_attrs)
      assert regra_evento_criticidade.descricao == "some descricao"
      assert regra_evento_criticidade.tipo_evento_criticidade == :Falha
      assert regra_evento_criticidade.condicao == :Maior
      assert regra_evento_criticidade.propriedade_verificar == :Temperatura
      assert regra_evento_criticidade.valor_propriedade == 120.5
      assert regra_evento_criticidade.prioridade == 42
      assert regra_evento_criticidade.impacto == :Nenhum
      assert regra_evento_criticidade.gera_incidente == true
    end

    test "create_regra_evento_criticidade/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Entidades.create_regra_evento_criticidade(@invalid_attrs)
    end

    test "update_regra_evento_criticidade/2 with valid data updates the regra_evento_criticidade" do
      regra_evento_criticidade = regra_evento_criticidade_fixture()
      update_attrs = %{descricao: "some updated descricao", tipo_evento_criticidade: :Alerta, condicao: :Igual, propriedade_verificar: :"Porcentagem de Uso", valor_propriedade: 456.7, prioridade: 43, impacto: :Baixo, gera_incidente: false}

      assert {:ok, %RegraEventoCriticidade{} = regra_evento_criticidade} = Entidades.update_regra_evento_criticidade(regra_evento_criticidade, update_attrs)
      assert regra_evento_criticidade.descricao == "some updated descricao"
      assert regra_evento_criticidade.tipo_evento_criticidade == :Alerta
      assert regra_evento_criticidade.condicao == :Igual
      assert regra_evento_criticidade.propriedade_verificar == :"Porcentagem de Uso"
      assert regra_evento_criticidade.valor_propriedade == 456.7
      assert regra_evento_criticidade.prioridade == 43
      assert regra_evento_criticidade.impacto == :Baixo
      assert regra_evento_criticidade.gera_incidente == false
    end

    test "update_regra_evento_criticidade/2 with invalid data returns error changeset" do
      regra_evento_criticidade = regra_evento_criticidade_fixture()
      assert {:error, %Ecto.Changeset{}} = Entidades.update_regra_evento_criticidade(regra_evento_criticidade, @invalid_attrs)
      assert regra_evento_criticidade == Entidades.get_regra_evento_criticidade!(regra_evento_criticidade.id)
    end

    test "delete_regra_evento_criticidade/1 deletes the regra_evento_criticidade" do
      regra_evento_criticidade = regra_evento_criticidade_fixture()
      assert {:ok, %RegraEventoCriticidade{}} = Entidades.delete_regra_evento_criticidade(regra_evento_criticidade)
      assert_raise Ecto.NoResultsError, fn -> Entidades.get_regra_evento_criticidade!(regra_evento_criticidade.id) end
    end

    test "change_regra_evento_criticidade/1 returns a regra_evento_criticidade changeset" do
      regra_evento_criticidade = regra_evento_criticidade_fixture()
      assert %Ecto.Changeset{} = Entidades.change_regra_evento_criticidade(regra_evento_criticidade)
    end
  end
end
