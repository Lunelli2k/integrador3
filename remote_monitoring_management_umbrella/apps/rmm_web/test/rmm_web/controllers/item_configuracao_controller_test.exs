defmodule RmmWeb.ItemConfiguracaoControllerTest do
  use RmmWeb.ConnCase

  import Rmm.EstruturasDeDados.EntidadesFixtures

  @create_attrs %{descricao: "some descricao", fabricante: "some fabricante", marca: "some marca", porcentagem_uso: 120.5, temperatura: 120.5, situacao: :Ativo, capacidade_gb: 42, tipo: "some tipo", nucleos: 42, frequencia_mhz: 42, categoria: :CPU, codigo_integracao: "some codigo_integracao"}
  @update_attrs %{descricao: "some updated descricao", fabricante: "some updated fabricante", marca: "some updated marca", porcentagem_uso: 456.7, temperatura: 456.7, situacao: :"1", capacidade_gb: 43, tipo: "some updated tipo", nucleos: 43, frequencia_mhz: 43, categoria: :"Memória Principal", codigo_integracao: "some updated codigo_integracao"}
  @invalid_attrs %{descricao: nil, fabricante: nil, marca: nil, porcentagem_uso: nil, temperatura: nil, situacao: nil, capacidade_gb: nil, tipo: nil, nucleos: nil, frequencia_mhz: nil, categoria: nil, codigo_integracao: nil}

  describe "index" do
    test "lists all itens_configuracao", %{conn: conn} do
      conn = get(conn, ~p"/itens_configuracao")
      assert html_response(conn, 200) =~ "Listing Itens configuracao"
    end
  end

  describe "new item_configuracao" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/itens_configuracao/new")
      assert html_response(conn, 200) =~ "New Item configuracao"
    end
  end

  describe "create item_configuracao" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/itens_configuracao", item_configuracao: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/itens_configuracao/#{id}"

      conn = get(conn, ~p"/itens_configuracao/#{id}")
      assert html_response(conn, 200) =~ "Item configuracao #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/itens_configuracao", item_configuracao: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Item configuracao"
    end
  end

  describe "edit item_configuracao" do
    setup [:create_item_configuracao]

    test "renders form for editing chosen item_configuracao", %{conn: conn, item_configuracao: item_configuracao} do
      conn = get(conn, ~p"/itens_configuracao/#{item_configuracao}/edit")
      assert html_response(conn, 200) =~ "Edit Item configuracao"
    end
  end

  describe "update item_configuracao" do
    setup [:create_item_configuracao]

    test "redirects when data is valid", %{conn: conn, item_configuracao: item_configuracao} do
      conn = put(conn, ~p"/itens_configuracao/#{item_configuracao}", item_configuracao: @update_attrs)
      assert redirected_to(conn) == ~p"/itens_configuracao/#{item_configuracao}"

      conn = get(conn, ~p"/itens_configuracao/#{item_configuracao}")
      assert html_response(conn, 200) =~ "some updated descricao"
    end

    test "renders errors when data is invalid", %{conn: conn, item_configuracao: item_configuracao} do
      conn = put(conn, ~p"/itens_configuracao/#{item_configuracao}", item_configuracao: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Item configuracao"
    end
  end

  describe "delete item_configuracao" do
    setup [:create_item_configuracao]

    test "deletes chosen item_configuracao", %{conn: conn, item_configuracao: item_configuracao} do
      conn = delete(conn, ~p"/itens_configuracao/#{item_configuracao}")
      assert redirected_to(conn) == ~p"/itens_configuracao"

      assert_error_sent 404, fn ->
        get(conn, ~p"/itens_configuracao/#{item_configuracao}")
      end
    end
  end

  defp create_item_configuracao(_) do
    item_configuracao = item_configuracao_fixture()
    %{item_configuracao: item_configuracao}
  end
end
