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
end
