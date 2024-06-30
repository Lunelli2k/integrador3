defmodule RmmWeb.ItemConfiguracaoController do
  use RmmWeb, :controller

  alias Rmm.EstruturasDeDados.Entidades
  alias Rmm.EstruturasDeDados.Entidades.ItemConfiguracao

  def index(conn, _params) do
    itens_configuracao = Entidades.list_itens_configuracao()
    render(conn, :index, itens_configuracao: itens_configuracao)
  end

  def show(conn, %{"id" => id}) do
    item_configuracao = Entidades.get_item_configuracao!(id)
    render(conn, :show, item_configuracao: item_configuracao)
  end

  def edit(conn, %{"id" => id}) do
    item_configuracao = Entidades.get_item_configuracao!(id)
    changeset = Entidades.change_item_configuracao(item_configuracao)
    render(conn, :edit, item_configuracao: item_configuracao, changeset: changeset)
  end

  def update(conn, %{"id" => id, "item_configuracao" => item_configuracao_params}) do
    item_configuracao = Entidades.get_item_configuracao!(id)

    case Entidades.update_item_configuracao(item_configuracao, item_configuracao_params) do
      {:ok, item_configuracao} ->
        conn
        |> put_flash(:info, "Item configuracao updated successfully.")
        |> redirect(to: ~p"/itens_configuracao/#{item_configuracao}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, item_configuracao: item_configuracao, changeset: changeset)
    end
  end

end
