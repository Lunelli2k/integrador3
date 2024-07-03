defmodule Rmm.EstruturasDeDados.Entidades do
  @moduledoc """
  The EstruturasDeDados.Entidades context.
  """

  import Ecto.Query, warn: false
  alias Rmm.Repo

  alias Rmm.EstruturasDeDados.Entidades.{User, UserToken, UserNotifier}

  ## Database getters

  @doc """
  Gets a user by email.

  ## Examples

      iex> get_user_by_email("foo@example.com")
      %User{}

      iex> get_user_by_email("unknown@example.com")
      nil

  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a user by email and password.

  ## Examples

      iex> get_user_by_email_and_password("foo@example.com", "correct_password")
      %User{}

      iex> get_user_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password), do: user
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

  ## User registration

  @doc """
  Registers a user.

  ## Examples

      iex> register_user(%{field: value})
      {:ok, %User{}}

      iex> register_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user_registration(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, hash_password: false, validate_email: false)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user email.

  ## Examples

      iex> change_user_email(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_email(user, attrs \\ %{}) do
    User.email_changeset(user, attrs, validate_email: false)
  end

  @doc """
  Emulates that the email will change without actually changing
  it in the database.

  ## Examples

      iex> apply_user_email(user, "valid password", %{email: ...})
      {:ok, %User{}}

      iex> apply_user_email(user, "invalid password", %{email: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_user_email(user, password, attrs) do
    user
    |> User.email_changeset(attrs)
    |> User.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the user email using the given token.

  If the token matches, the user email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_user_email(user, token) do
    context = "change:#{user.email}"

    with {:ok, query} <- UserToken.verify_change_email_token_query(token, context),
         %UserToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(user_email_multi(user, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp user_email_multi(user, email, context) do
    changeset =
      user
      |> User.email_changeset(%{email: email})
      |> User.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, [context]))
  end

  @doc ~S"""
  Delivers the update email instructions to the given user.

  ## Examples

      iex> deliver_user_update_email_instructions(user, current_email, &url(~p"/user/settings/confirm_email/#{&1})")
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_user_update_email_instructions(%User{} = user, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "change:#{current_email}")

    Repo.insert!(user_token)
    UserNotifier.deliver_update_email_instructions(user, update_email_url_fun.(encoded_token))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the user password.

  ## Examples

      iex> change_user_password(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user_password(user, attrs \\ %{}) do
    User.password_changeset(user, attrs, hash_password: false)
  end

  @doc """
  Updates the user password.

  ## Examples

      iex> update_user_password(user, "valid password", %{password: ...})
      {:ok, %User{}}

      iex> update_user_password(user, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_password(user, password, attrs) do
    changeset =
      user
      |> User.password_changeset(attrs)
      |> User.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, changeset)
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    token
  end

  @doc """
  Gets the user with the given signed token.
  """
  def get_user_by_session_token(token) do
    {:ok, query} = UserToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_user_session_token(token) do
    Repo.delete_all(UserToken.by_token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation

  @doc ~S"""
  Delivers the confirmation email instructions to the given user.

  ## Examples

      iex> deliver_user_confirmation_instructions(user, &url(~p"/user/confirm/#{&1}"))
      {:ok, %{to: ..., body: ...}}

      iex> deliver_user_confirmation_instructions(confirmed_user, &url(~p"/user/confirm/#{&1}"))
      {:error, :already_confirmed}

  """
  def deliver_user_confirmation_instructions(%User{} = user, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    if user.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, user_token} = UserToken.build_email_token(user, "confirm")
      Repo.insert!(user_token)
      UserNotifier.deliver_confirmation_instructions(user, confirmation_url_fun.(encoded_token))
    end
  end

  @doc """
  Confirms a user by the given token.

  If the token matches, the user account is marked as confirmed
  and the token is deleted.
  """
  def confirm_user(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "confirm"),
         %User{} = user <- Repo.one(query),
         {:ok, %{user: user}} <- Repo.transaction(confirm_user_multi(user)) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  defp confirm_user_multi(user) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.confirm_changeset(user))
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, ["confirm"]))
  end

  ## Reset password

  @doc ~S"""
  Delivers the reset password email to the given user.

  ## Examples

      iex> deliver_user_reset_password_instructions(user, &url(~p"/user/reset_password/#{&1}"))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_user_reset_password_instructions(%User{} = user, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, user_token} = UserToken.build_email_token(user, "reset_password")
    Repo.insert!(user_token)
    UserNotifier.deliver_reset_password_instructions(user, reset_password_url_fun.(encoded_token))
  end

  @doc """
  Gets the user by reset password token.

  ## Examples

      iex> get_user_by_reset_password_token("validtoken")
      %User{}

      iex> get_user_by_reset_password_token("invalidtoken")
      nil

  """
  def get_user_by_reset_password_token(token) do
    with {:ok, query} <- UserToken.verify_email_token_query(token, "reset_password"),
         %User{} = user <- Repo.one(query) do
      user
    else
      _ -> nil
    end
  end

  @doc """
  Resets the user password.

  ## Examples

      iex> reset_user_password(user, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %User{}}

      iex> reset_user_password(user, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  def reset_user_password(user, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user, User.password_changeset(user, attrs))
    |> Ecto.Multi.delete_all(:tokens, UserToken.by_user_and_contexts_query(user, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  alias Rmm.EstruturasDeDados.Entidades.ItemConfiguracao

  @doc """
  Returns the list of itens_configuracao.

  ## Examples

      iex> list_itens_configuracao()
      [%ItemConfiguracao{}, ...]

  """
  def list_itens_configuracao do
    Repo.all(ItemConfiguracao)
  end

  @doc """
  Gets a single item_configuracao.

  Raises `Ecto.NoResultsError` if the Item configuracao does not exist.

  ## Examples

      iex> get_item_configuracao!(123)
      %ItemConfiguracao{}

      iex> get_item_configuracao!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item_configuracao!(id), do: Repo.get!(ItemConfiguracao, id)

  @doc """
  Creates a item_configuracao.

  ## Examples

      iex> create_item_configuracao(%{field: value})
      {:ok, %ItemConfiguracao{}}

      iex> create_item_configuracao(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item_configuracao(attrs \\ %{}) do
    %ItemConfiguracao{}
    |> ItemConfiguracao.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a item_configuracao.

  ## Examples

      iex> update_item_configuracao(item_configuracao, %{field: new_value})
      {:ok, %ItemConfiguracao{}}

      iex> update_item_configuracao(item_configuracao, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item_configuracao(%ItemConfiguracao{} = item_configuracao, attrs) do
    item_configuracao
    |> ItemConfiguracao.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a item_configuracao.

  ## Examples

      iex> delete_item_configuracao(item_configuracao)
      {:ok, %ItemConfiguracao{}}

      iex> delete_item_configuracao(item_configuracao)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item_configuracao(%ItemConfiguracao{} = item_configuracao) do
    Repo.delete(item_configuracao)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item_configuracao changes.

  ## Examples

      iex> change_item_configuracao(item_configuracao)
      %Ecto.Changeset{data: %ItemConfiguracao{}}

  """
  def change_item_configuracao(%ItemConfiguracao{} = item_configuracao, attrs \\ %{}) do
    ItemConfiguracao.changeset(item_configuracao, attrs)
  end

  alias Rmm.EstruturasDeDados.Entidades.SolucaoContorno

  @doc """
  Returns the list of solucoes_contorno.

  ## Examples

      iex> list_solucoes_contorno()
      [%SolucaoContorno{}, ...]

  """
  def list_solucoes_contorno do
    Repo.all(SolucaoContorno)
  end

  @doc """
  Gets a single solucao_contorno.

  Raises `Ecto.NoResultsError` if the Solucao contorno does not exist.

  ## Examples

      iex> get_solucao_contorno!(123)
      %SolucaoContorno{}

      iex> get_solucao_contorno!(456)
      ** (Ecto.NoResultsError)

  """
  def get_solucao_contorno!(id), do: Repo.get!(SolucaoContorno, id)

  @doc """
  Creates a solucao_contorno.

  ## Examples

      iex> create_solucao_contorno(%{field: value})
      {:ok, %SolucaoContorno{}}

      iex> create_solucao_contorno(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_solucao_contorno(attrs \\ %{}) do
    %SolucaoContorno{}
    |> SolucaoContorno.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a solucao_contorno.

  ## Examples

      iex> update_solucao_contorno(solucao_contorno, %{field: new_value})
      {:ok, %SolucaoContorno{}}

      iex> update_solucao_contorno(solucao_contorno, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_solucao_contorno(%SolucaoContorno{} = solucao_contorno, attrs) do
    solucao_contorno
    |> SolucaoContorno.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a solucao_contorno.

  ## Examples

      iex> delete_solucao_contorno(solucao_contorno)
      {:ok, %SolucaoContorno{}}

      iex> delete_solucao_contorno(solucao_contorno)
      {:error, %Ecto.Changeset{}}

  """
  def delete_solucao_contorno(%SolucaoContorno{} = solucao_contorno) do
    Repo.delete(solucao_contorno)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking solucao_contorno changes.

  ## Examples

      iex> change_solucao_contorno(solucao_contorno)
      %Ecto.Changeset{data: %SolucaoContorno{}}

  """
  def change_solucao_contorno(%SolucaoContorno{} = solucao_contorno, attrs \\ %{}) do
    SolucaoContorno.changeset(solucao_contorno, attrs)
  end

  alias Rmm.EstruturasDeDados.Entidades.Incidente

  @doc """
  Returns the list of incidentes.

  ## Examples

      iex> list_incidentes()
      [%Incidente{}, ...]

  """
  def list_incidentes do
    Repo.all(Incidente)
  end

  @doc """
  Gets a single incidente.

  Raises `Ecto.NoResultsError` if the Incidente does not exist.

  ## Examples

      iex> get_incidente!(123)
      %Incidente{}

      iex> get_incidente!(456)
      ** (Ecto.NoResultsError)

  """
  def get_incidente!(id), do: Repo.get!(Incidente, id)

  @doc """
  Creates a incidente.

  ## Examples

      iex> create_incidente(%{field: value})
      {:ok, %Incidente{}}

      iex> create_incidente(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_incidente(attrs \\ %{}) do
    %Incidente{}
    |> Incidente.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a incidente.

  ## Examples

      iex> update_incidente(incidente, %{field: new_value})
      {:ok, %Incidente{}}

      iex> update_incidente(incidente, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_incidente(%Incidente{} = incidente, attrs) do
    incidente
    |> Incidente.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a incidente.

  ## Examples

      iex> delete_incidente(incidente)
      {:ok, %Incidente{}}

      iex> delete_incidente(incidente)
      {:error, %Ecto.Changeset{}}

  """
  def delete_incidente(%Incidente{} = incidente) do
    Repo.delete(incidente)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking incidente changes.

  ## Examples

      iex> change_incidente(incidente)
      %Ecto.Changeset{data: %Incidente{}}

  """
  def change_incidente(%Incidente{} = incidente, attrs \\ %{}) do
    Incidente.changeset(incidente, attrs)
  end

  alias Rmm.EstruturasDeDados.Entidades.RegraEventoCriticidade

  @doc """
  Returns the list of regras_eventos_criticidade.

  ## Examples

      iex> list_regras_eventos_criticidade()
      [%RegraEventoCriticidade{}, ...]

  """
  def list_regras_eventos_criticidade do
    Repo.all(RegraEventoCriticidade)
  end

  @doc """
  Gets a single regra_evento_criticidade.

  Raises `Ecto.NoResultsError` if the Regra evento criticidade does not exist.

  ## Examples

      iex> get_regra_evento_criticidade!(123)
      %RegraEventoCriticidade{}

      iex> get_regra_evento_criticidade!(456)
      ** (Ecto.NoResultsError)

  """
  def get_regra_evento_criticidade!(id), do: Repo.get!(RegraEventoCriticidade, id)

  @doc """
  Creates a regra_evento_criticidade.

  ## Examples

      iex> create_regra_evento_criticidade(%{field: value})
      {:ok, %RegraEventoCriticidade{}}

      iex> create_regra_evento_criticidade(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_regra_evento_criticidade(attrs \\ %{}) do
    %RegraEventoCriticidade{}
    |> RegraEventoCriticidade.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a regra_evento_criticidade.

  ## Examples

      iex> update_regra_evento_criticidade(regra_evento_criticidade, %{field: new_value})
      {:ok, %RegraEventoCriticidade{}}

      iex> update_regra_evento_criticidade(regra_evento_criticidade, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_regra_evento_criticidade(%RegraEventoCriticidade{} = regra_evento_criticidade, attrs) do
    regra_evento_criticidade
    |> RegraEventoCriticidade.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a regra_evento_criticidade.

  ## Examples

      iex> delete_regra_evento_criticidade(regra_evento_criticidade)
      {:ok, %RegraEventoCriticidade{}}

      iex> delete_regra_evento_criticidade(regra_evento_criticidade)
      {:error, %Ecto.Changeset{}}

  """
  def delete_regra_evento_criticidade(%RegraEventoCriticidade{} = regra_evento_criticidade) do
    Repo.delete(regra_evento_criticidade)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking regra_evento_criticidade changes.

  ## Examples

      iex> change_regra_evento_criticidade(regra_evento_criticidade)
      %Ecto.Changeset{data: %RegraEventoCriticidade{}}

  """
  def change_regra_evento_criticidade(%RegraEventoCriticidade{} = regra_evento_criticidade, attrs \\ %{}) do
    RegraEventoCriticidade.changeset(regra_evento_criticidade, attrs)
  end
end
