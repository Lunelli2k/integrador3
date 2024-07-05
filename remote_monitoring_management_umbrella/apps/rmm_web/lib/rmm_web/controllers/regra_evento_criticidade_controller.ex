defmodule RmmWeb.RegraEventoCriticidadeController do
  use RmmWeb, :controller

  alias Rmm.EstruturasDeDados.Entidades
  alias Rmm.Repo

  def index(conn, _params) do
    regras_eventos_criticidade = Entidades.list_regras_eventos_criticidade()
    render(conn, :index, regras_eventos_criticidade: regras_eventos_criticidade)
  end

  def new(conn, _params) do
    changeset = Entidades.change_regra_evento_criticidade(%Rmm.EstruturasDeDados.Entidades.RegraEventoCriticidade{})
    itens_configuracao = Repo.all(Rmm.EstruturasDeDados.Entidades.ItemConfiguracao)
    solucoes_contorno = Repo.all(Rmm.EstruturasDeDados.Entidades.SolucaoContorno)

    render(conn, :new, changeset: changeset, itens_configuracao: itens_configuracao, solucoes_contorno: solucoes_contorno)
  end

  def create(conn, %{"regra_evento_criticidade" => regra_evento_criticidade_params}) do
    case Entidades.create_regra_evento_criticidade(regra_evento_criticidade_params) do
      {:ok, regra_evento_criticidade} ->
        conn
        |> put_flash(:info, "Regra de Evento de Criticidade criada com sucesso.")
        |> redirect(to: ~p"/regras_eventos_criticidade/#{regra_evento_criticidade}")

      {:error, %Ecto.Changeset{} = changeset} ->
        itens_configuracao = Repo.all(Rmm.EstruturasDeDados.Entidades.ItemConfiguracao)
        solucoes_contorno = Repo.all(Rmm.EstruturasDeDados.Entidades.SolucaoContorno)

        render(conn, :new, changeset: changeset, itens_configuracao: itens_configuracao, solucoes_contorno: solucoes_contorno)
    end
  end

  def show(conn, %{"id" => id}) do
    regra_evento_criticidade = Entidades.get_regra_evento_criticidade!(id)

    solucao_contorno = if regra_evento_criticidade.solucao_contorno_id do
      Repo.get_by(Rmm.EstruturasDeDados.Entidades.SolucaoContorno, id: regra_evento_criticidade.solucao_contorno_id)
    else
      nil
    end

    item_config = if regra_evento_criticidade.item_configuracao_id do
      Repo.get_by(Rmm.EstruturasDeDados.Entidades.ItemConfiguracao, id: regra_evento_criticidade.item_configuracao_id)
    else
      nil
    end

    render(conn, :show, regra_evento_criticidade: regra_evento_criticidade, item_config: item_config, solucao_contorno: solucao_contorno)
  end

  def edit(conn, %{"id" => id}) do
    regra_evento_criticidade = Entidades.get_regra_evento_criticidade!(id)
    changeset = Entidades.change_regra_evento_criticidade(regra_evento_criticidade)
    itens_configuracao = Repo.all(Rmm.EstruturasDeDados.Entidades.ItemConfiguracao)
    solucoes_contorno = Repo.all(Rmm.EstruturasDeDados.Entidades.SolucaoContorno)

    render(conn, :edit, regra_evento_criticidade: regra_evento_criticidade, changeset: changeset, itens_configuracao: itens_configuracao, solucoes_contorno: solucoes_contorno)
  end

  def update(conn, %{"id" => id, "regra_evento_criticidade" => regra_evento_criticidade_params}) do
    regra_evento_criticidade = Entidades.get_regra_evento_criticidade!(id)

    case Entidades.update_regra_evento_criticidade(regra_evento_criticidade, regra_evento_criticidade_params) do
      {:ok, regra_evento_criticidade} ->
        conn
        |> put_flash(:info, "Regra de Evento de Criticidade atualizada com sucesso.")
        |> redirect(to: ~p"/regras_eventos_criticidade/#{regra_evento_criticidade}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, regra_evento_criticidade: regra_evento_criticidade, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    regra_evento_criticidade = Entidades.get_regra_evento_criticidade!(id)
    {:ok, _regra_evento_criticidade} = Entidades.delete_regra_evento_criticidade(regra_evento_criticidade)

    conn
    |> put_flash(:info, "Regra de Evento de Criticidade deletada com sucesso.")
    |> redirect(to: ~p"/regras_eventos_criticidade")
  end
end
