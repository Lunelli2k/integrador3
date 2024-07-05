defmodule RmmWeb.SolucaoContornoControllerTest do
  use RmmWeb.ConnCase

  import Rmm.EstruturasDeDadosFixtures

  @create_attrs %{descricao: "some descricao", situacao: :Ativo, solucao: "some solucao"}
  @update_attrs %{descricao: "some updated descricao", situacao: :Inativo, solucao: "some updated solucao"}
  @invalid_attrs %{descricao: nil, situacao: nil, solucao: nil}

  describe "index" do
    test "lists all solucoes_contorno", %{conn: conn} do
      conn = get(conn, ~p"/solucoes_contorno")
      assert html_response(conn, 200) =~ "Listing Solucoes contorno"
    end
  end

  describe "new solucao_contorno" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/solucoes_contorno/new")
      assert html_response(conn, 200) =~ "New Solucao contorno"
    end
  end

  describe "create solucao_contorno" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/solucoes_contorno", solucao_contorno: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/solucoes_contorno/#{id}"

      conn = get(conn, ~p"/solucoes_contorno/#{id}")
      assert html_response(conn, 200) =~ "Solucao contorno #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/solucoes_contorno", solucao_contorno: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Solucao contorno"
    end
  end

  describe "edit solucao_contorno" do
    setup [:create_solucao_contorno]

    test "renders form for editing chosen solucao_contorno", %{conn: conn, solucao_contorno: solucao_contorno} do
      conn = get(conn, ~p"/solucoes_contorno/#{solucao_contorno}/edit")
      assert html_response(conn, 200) =~ "Edit Solucao contorno"
    end
  end

  describe "update solucao_contorno" do
    setup [:create_solucao_contorno]

    test "redirects when data is valid", %{conn: conn, solucao_contorno: solucao_contorno} do
      conn = put(conn, ~p"/solucoes_contorno/#{solucao_contorno}", solucao_contorno: @update_attrs)
      assert redirected_to(conn) == ~p"/solucoes_contorno/#{solucao_contorno}"

      conn = get(conn, ~p"/solucoes_contorno/#{solucao_contorno}")
      assert html_response(conn, 200) =~ "some updated descricao"
    end

    test "renders errors when data is invalid", %{conn: conn, solucao_contorno: solucao_contorno} do
      conn = put(conn, ~p"/solucoes_contorno/#{solucao_contorno}", solucao_contorno: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Solucao contorno"
    end
  end

  describe "delete solucao_contorno" do
    setup [:create_solucao_contorno]

    test "deletes chosen solucao_contorno", %{conn: conn, solucao_contorno: solucao_contorno} do
      conn = delete(conn, ~p"/solucoes_contorno/#{solucao_contorno}")
      assert redirected_to(conn) == ~p"/solucoes_contorno"

      assert_error_sent 404, fn ->
        get(conn, ~p"/solucoes_contorno/#{solucao_contorno}")
      end
    end
  end

  defp create_solucao_contorno(_) do
    solucao_contorno = solucao_contorno_fixture()
    %{solucao_contorno: solucao_contorno}
  end
end
