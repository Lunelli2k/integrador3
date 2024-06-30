defmodule RmmWeb.IncidenteControllerTest do
  use RmmWeb.ConnCase

  import Rmm.EstruturasDeDados.EntidadesFixtures

  @create_attrs %{codigo: 42, descricao: "some descricao", codigo_item_configuracao: 42, codigo_solucao_contorno: 42, situacao: :Aberto, observacao: "some observacao", impacto: :Nenhum, prioridade: 42, codigo_regra_evento_criticidade: 42, data_geracao: ~U[2024-06-29 15:02:00Z]}
  @update_attrs %{codigo: 43, descricao: "some updated descricao", codigo_item_configuracao: 43, codigo_solucao_contorno: 43, situacao: :Solucionando, observacao: "some updated observacao", impacto: :Baixo, prioridade: 43, codigo_regra_evento_criticidade: 43, data_geracao: ~U[2024-06-30 15:02:00Z]}
  @invalid_attrs %{codigo: nil, descricao: nil, codigo_item_configuracao: nil, codigo_solucao_contorno: nil, situacao: nil, observacao: nil, impacto: nil, prioridade: nil, codigo_regra_evento_criticidade: nil, data_geracao: nil}

  describe "index" do
    test "lists all incidentes", %{conn: conn} do
      conn = get(conn, ~p"/incidentes")
      assert html_response(conn, 200) =~ "Listing Incidentes"
    end
  end

  describe "new incidente" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/incidentes/new")
      assert html_response(conn, 200) =~ "New Incidente"
    end
  end

  describe "create incidente" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/incidentes", incidente: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/incidentes/#{id}"

      conn = get(conn, ~p"/incidentes/#{id}")
      assert html_response(conn, 200) =~ "Incidente #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/incidentes", incidente: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Incidente"
    end
  end

  describe "edit incidente" do
    setup [:create_incidente]

    test "renders form for editing chosen incidente", %{conn: conn, incidente: incidente} do
      conn = get(conn, ~p"/incidentes/#{incidente}/edit")
      assert html_response(conn, 200) =~ "Edit Incidente"
    end
  end

  describe "update incidente" do
    setup [:create_incidente]

    test "redirects when data is valid", %{conn: conn, incidente: incidente} do
      conn = put(conn, ~p"/incidentes/#{incidente}", incidente: @update_attrs)
      assert redirected_to(conn) == ~p"/incidentes/#{incidente}"

      conn = get(conn, ~p"/incidentes/#{incidente}")
      assert html_response(conn, 200) =~ "some updated descricao"
    end

    test "renders errors when data is invalid", %{conn: conn, incidente: incidente} do
      conn = put(conn, ~p"/incidentes/#{incidente}", incidente: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Incidente"
    end
  end

  describe "delete incidente" do
    setup [:create_incidente]

    test "deletes chosen incidente", %{conn: conn, incidente: incidente} do
      conn = delete(conn, ~p"/incidentes/#{incidente}")
      assert redirected_to(conn) == ~p"/incidentes"

      assert_error_sent 404, fn ->
        get(conn, ~p"/incidentes/#{incidente}")
      end
    end
  end

  defp create_incidente(_) do
    incidente = incidente_fixture()
    %{incidente: incidente}
  end
end
