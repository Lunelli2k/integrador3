defmodule Rmm.EstruturasDeDados do
  @moduledoc """
  The EstruturasDeDados context.
  """

  import Ecto.Query, warn: false
  alias Rmm.Repo

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
end
