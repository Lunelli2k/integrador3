defmodule RmmWeb.RegraEventoCriticidadeController do
  use RmmWeb, :controller

  alias Rmm.EstruturasDeDados.Entidades
  alias Rmm.EstruturasDeDados.Entidades.RegraEventoCriticidade

  def index(conn, _params) do
    regras_eventos_criticidade = Entidades.list_regras_eventos_criticidade()
    render(conn, :index, regras_eventos_criticidade: regras_eventos_criticidade)
  end

  def new(conn, _params) do
    changeset = Entidades.change_regra_evento_criticidade(%RegraEventoCriticidade{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"regra_evento_criticidade" => regra_evento_criticidade_params}) do
    case Entidades.create_regra_evento_criticidade(regra_evento_criticidade_params) do
      {:ok, regra_evento_criticidade} ->
        conn
        |> put_flash(:info, "Regra evento criticidade created successfully.")
        |> redirect(to: ~p"/regras_eventos_criticidade/#{regra_evento_criticidade}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    regra_evento_criticidade = Entidades.get_regra_evento_criticidade!(id)
    render(conn, :show, regra_evento_criticidade: regra_evento_criticidade)
  end

  def edit(conn, %{"id" => id}) do
    regra_evento_criticidade = Entidades.get_regra_evento_criticidade!(id)
    changeset = Entidades.change_regra_evento_criticidade(regra_evento_criticidade)
    render(conn, :edit, regra_evento_criticidade: regra_evento_criticidade, changeset: changeset)
  end

  def update(conn, %{"id" => id, "regra_evento_criticidade" => regra_evento_criticidade_params}) do
    regra_evento_criticidade = Entidades.get_regra_evento_criticidade!(id)

    case Entidades.update_regra_evento_criticidade(regra_evento_criticidade, regra_evento_criticidade_params) do
      {:ok, regra_evento_criticidade} ->
        conn
        |> put_flash(:info, "Regra evento criticidade updated successfully.")
        |> redirect(to: ~p"/regras_eventos_criticidade/#{regra_evento_criticidade}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, regra_evento_criticidade: regra_evento_criticidade, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    regra_evento_criticidade = Entidades.get_regra_evento_criticidade!(id)
    {:ok, _regra_evento_criticidade} = Entidades.delete_regra_evento_criticidade(regra_evento_criticidade)

    conn
    |> put_flash(:info, "Regra evento criticidade deleted successfully.")
    |> redirect(to: ~p"/regras_eventos_criticidade")
  end
end
