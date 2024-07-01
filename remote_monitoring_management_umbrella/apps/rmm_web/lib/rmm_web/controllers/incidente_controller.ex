defmodule RmmWeb.IncidenteController do
  use RmmWeb, :controller

  alias Rmm.EstruturasDeDados.Entidades
  alias Rmm.EstruturasDeDados.Entidades.Incidente

  def index(conn, _params) do
    incidentes = Entidades.list_incidentes()
    render(conn, :index, incidentes: incidentes)
  end

  def new(conn, _params) do
    changeset = Entidades.change_incidente(%Incidente{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"incidente" => incidente_params}) do
    case Entidades.create_incidente(incidente_params) do
      {:ok, incidente} ->
        conn
        |> put_flash(:info, "Incidente created successfully.")
        |> redirect(to: ~p"/incidentes/#{incidente}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    incidente = Entidades.get_incidente!(id)
    render(conn, :show, incidente: incidente)
  end

  def edit(conn, %{"id" => id}) do
    incidente = Entidades.get_incidente!(id)
    changeset = Entidades.change_incidente(incidente)
    render(conn, :edit, incidente: incidente, changeset: changeset)
  end

  def update(conn, %{"id" => id, "incidente" => incidente_params}) do
    incidente = Entidades.get_incidente!(id)

    case Entidades.update_incidente(incidente, incidente_params) do
      {:ok, incidente} ->
        conn
        |> put_flash(:info, "Incidente updated successfully.")
        |> redirect(to: ~p"/incidentes/#{incidente}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, incidente: incidente, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    incidente = Entidades.get_incidente!(id)
    {:ok, _incidente} = Entidades.delete_incidente(incidente)

    conn
    |> put_flash(:info, "Incidente deleted successfully.")
    |> redirect(to: ~p"/incidentes")
  end
end
