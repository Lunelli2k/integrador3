defmodule RmmWeb.IncidenteController do
  use RmmWeb, :controller

  alias Rmm.EstruturasDeDados
  alias Rmm.Repo

  alias Rmm.EstruturasDeDados.Entidades.{Incidente, ItemConfiguracao, SolucaoContorno, RegraEventoCriticidade}


  def index(conn, _params) do
    incidentes = EstruturasDeDados.list_incidentes()
    render(conn, :index, incidentes: incidentes)
  end

  def new(conn, _params) do
    itens_configuracao = Repo.all(ItemConfiguracao)
    solucoes_contorno = Repo.all(SolucaoContorno)
    regras_eventos_criticidade = Repo.all(RegraEventoCriticidade)

    changeset = EstruturasDeDados.change_incidente(%Incidente{})
    render(conn, :new, changeset: changeset, itens_configuracao: itens_configuracao, solucoes_contorno: solucoes_contorno, regras_eventos_criticidade: regras_eventos_criticidade)
  end

  def create(conn, %{"incidente" => incidente_params}) do
    case EstruturasDeDados.create_incidente(incidente_params) do
      {:ok, incidente} ->
        conn
        |> put_flash(:info, "Incidente created successfully.")
        |> redirect(to: ~p"/incidentes/#{incidente}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    incidente = EstruturasDeDados.get_incidente!(id)
    IO.inspect incidente

    solucao_contorno = if incidente.codigo_solucao_contorno do
      Repo.get_by(SolucaoContorno, id: incidente.codigo_solucao_contorno)
    else
      nil
    end

    item_config = if incidente.codigo_item_configuracao do
      Repo.get_by(ItemConfiguracao, id: incidente.codigo_item_configuracao)
    else
      nil
    end

    regra_evento = if incidente.codigo_regra_evento_criticidade do
      Repo.get_by(RegraEventoCriticidade, id: incidente.codigo_regra_evento_criticidade)
    else
      nil
    end

    render(conn, :show, incidente: incidente, solucao_contorno: solucao_contorno, item_config: item_config, regra_evento: regra_evento)
  end

  def edit(conn, %{"id" => id}) do
    incidente = EstruturasDeDados.get_incidente!(id)
    itens_configuracao = Repo.all(ItemConfiguracao)
    solucoes_contorno = Repo.all(SolucaoContorno)
    regras_eventos_criticidade = Repo.all(RegraEventoCriticidade)

    changeset = EstruturasDeDados.change_incidente(incidente)
    render(conn, :edit, incidente: incidente, changeset: changeset, incidente: incidente, itens_configuracao: itens_configuracao, solucoes_contorno: solucoes_contorno, regras_eventos_criticidade: regras_eventos_criticidade)
  end

  def update(conn, %{"id" => id, "incidente" => incidente_params}) do
    incidente = EstruturasDeDados.get_incidente!(id)

    case EstruturasDeDados.update_incidente(incidente, incidente_params) do
      {:ok, incidente} ->
        conn
        |> put_flash(:info, "Incidente updated successfully.")
        |> redirect(to: ~p"/incidentes/#{incidente}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, incidente: incidente, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    incidente = EstruturasDeDados.get_incidente!(id)
    {:ok, _incidente} = EstruturasDeDados.delete_incidente(incidente)

    conn
    |> put_flash(:info, "Incidente deleted successfully.")
    |> redirect(to: ~p"/incidentes")
  end
end
