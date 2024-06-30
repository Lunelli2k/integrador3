defmodule RmmWeb.RegraEventoCriticidadeControllerTest do
  use RmmWeb.ConnCase

  import Rmm.EstruturasDeDados.EntidadesFixtures

  @create_attrs %{descricao: "some descricao", tipo_evento_criticidade: :Falha, condicao: :Maior, propriedade_verificar: :Temperatura, valor_propriedade: 120.5, prioridade: 42, impacto: :Nenhum}
  @update_attrs %{descricao: "some updated descricao", tipo_evento_criticidade: :Alerta, condicao: :Igual, propriedade_verificar: :"Porcentagem de Uso", valor_propriedade: 456.7, prioridade: 43, impacto: :Baixo}
  @invalid_attrs %{descricao: nil, tipo_evento_criticidade: nil, condicao: nil, propriedade_verificar: nil, valor_propriedade: nil, prioridade: nil, impacto: nil}

  describe "index" do
    test "lists all regras_eventos_criticidade", %{conn: conn} do
      conn = get(conn, ~p"/regras_eventos_criticidade")
      assert html_response(conn, 200) =~ "Listing Regras eventos criticidade"
    end
  end

  describe "new regra_evento_criticidade" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/regras_eventos_criticidade/new")
      assert html_response(conn, 200) =~ "New Regra evento criticidade"
    end
  end

  describe "create regra_evento_criticidade" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/regras_eventos_criticidade", regra_evento_criticidade: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/regras_eventos_criticidade/#{id}"

      conn = get(conn, ~p"/regras_eventos_criticidade/#{id}")
      assert html_response(conn, 200) =~ "Regra evento criticidade #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/regras_eventos_criticidade", regra_evento_criticidade: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Regra evento criticidade"
    end
  end

  describe "edit regra_evento_criticidade" do
    setup [:create_regra_evento_criticidade]

    test "renders form for editing chosen regra_evento_criticidade", %{conn: conn, regra_evento_criticidade: regra_evento_criticidade} do
      conn = get(conn, ~p"/regras_eventos_criticidade/#{regra_evento_criticidade}/edit")
      assert html_response(conn, 200) =~ "Edit Regra evento criticidade"
    end
  end

  describe "update regra_evento_criticidade" do
    setup [:create_regra_evento_criticidade]

    test "redirects when data is valid", %{conn: conn, regra_evento_criticidade: regra_evento_criticidade} do
      conn = put(conn, ~p"/regras_eventos_criticidade/#{regra_evento_criticidade}", regra_evento_criticidade: @update_attrs)
      assert redirected_to(conn) == ~p"/regras_eventos_criticidade/#{regra_evento_criticidade}"

      conn = get(conn, ~p"/regras_eventos_criticidade/#{regra_evento_criticidade}")
      assert html_response(conn, 200) =~ "some updated descricao"
    end

    test "renders errors when data is invalid", %{conn: conn, regra_evento_criticidade: regra_evento_criticidade} do
      conn = put(conn, ~p"/regras_eventos_criticidade/#{regra_evento_criticidade}", regra_evento_criticidade: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Regra evento criticidade"
    end
  end

  describe "delete regra_evento_criticidade" do
    setup [:create_regra_evento_criticidade]

    test "deletes chosen regra_evento_criticidade", %{conn: conn, regra_evento_criticidade: regra_evento_criticidade} do
      conn = delete(conn, ~p"/regras_eventos_criticidade/#{regra_evento_criticidade}")
      assert redirected_to(conn) == ~p"/regras_eventos_criticidade"

      assert_error_sent 404, fn ->
        get(conn, ~p"/regras_eventos_criticidade/#{regra_evento_criticidade}")
      end
    end
  end

  defp create_regra_evento_criticidade(_) do
    regra_evento_criticidade = regra_evento_criticidade_fixture()
    %{regra_evento_criticidade: regra_evento_criticidade}
  end
end
