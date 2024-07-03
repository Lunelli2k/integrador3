defmodule RmmWeb.SolucaoContornoController do
  use RmmWeb, :controller

  alias Rmm.EstruturasDeDados.Entidades
  alias Rmm.EstruturasDeDados.Entidades.SolucaoContorno

  def index(conn, _params) do
    solucoes_contorno = Entidades.list_solucoes_contorno()
    render(conn, :index, solucoes_contorno: solucoes_contorno)
  end

  def new(conn, _params) do
    changeset = Entidades.change_solucao_contorno(%SolucaoContorno{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"solucao_contorno" => solucao_contorno_params}) do
    case Entidades.create_solucao_contorno(solucao_contorno_params) do
      {:ok, solucao_contorno} ->
        conn
        |> put_flash(:info, "Solucao contorno created successfully.")
        |> redirect(to: ~p"/solucoes_contorno/#{solucao_contorno}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    solucao_contorno = Entidades.get_solucao_contorno!(id)
    render(conn, :show, solucao_contorno: solucao_contorno)
  end

  def edit(conn, %{"id" => id}) do
    solucao_contorno = Entidades.get_solucao_contorno!(id)
    changeset = Entidades.change_solucao_contorno(solucao_contorno)
    render(conn, :edit, solucao_contorno: solucao_contorno, changeset: changeset)
  end

  def update(conn, %{"id" => id, "solucao_contorno" => solucao_contorno_params}) do
    solucao_contorno = Entidades.get_solucao_contorno!(id)

    case Entidades.update_solucao_contorno(solucao_contorno, solucao_contorno_params) do
      {:ok, solucao_contorno} ->
        conn
        |> put_flash(:info, "Solucao contorno updated successfully.")
        |> redirect(to: ~p"/solucoes_contorno/#{solucao_contorno}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, solucao_contorno: solucao_contorno, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    solucao_contorno = Entidades.get_solucao_contorno!(id)
    {:ok, _solucao_contorno} = Entidades.delete_solucao_contorno(solucao_contorno)

    conn
    |> put_flash(:info, "Solucao contorno deleted successfully.")
    |> redirect(to: ~p"/solucoes_contorno")
  end
end
