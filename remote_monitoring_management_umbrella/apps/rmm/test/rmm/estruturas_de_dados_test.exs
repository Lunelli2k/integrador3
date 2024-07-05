defmodule Rmm.EstruturasDeDadosTest do
  use Rmm.DataCase

  alias Rmm.EstruturasDeDados

  describe "incidentes" do
    alias Rmm.EstruturasDeDados.Entidades.Incidente

    import Rmm.EstruturasDeDadosFixtures

    @invalid_attrs %{descricao: nil, situacao: nil, observacao: nil, impacto: nil, prioridade: nil, data_geracao: nil}

    test "list_incidentes/0 returns all incidentes" do
      incidente = incidente_fixture()
      assert EstruturasDeDados.list_incidentes() == [incidente]
    end

    test "get_incidente!/1 returns the incidente with given id" do
      incidente = incidente_fixture()
      assert EstruturasDeDados.get_incidente!(incidente.id) == incidente
    end

    test "create_incidente/1 with valid data creates a incidente" do
      valid_attrs = %{descricao: "some descricao", situacao: :Aberto, observacao: "some observacao", impacto: :Nenhum, prioridade: 42, data_geracao: ~U[2024-07-01 22:48:00Z]}

      assert {:ok, %Incidente{} = incidente} = EstruturasDeDados.create_incidente(valid_attrs)
      assert incidente.descricao == "some descricao"
      assert incidente.situacao == :Aberto
      assert incidente.observacao == "some observacao"
      assert incidente.impacto == :Nenhum
      assert incidente.prioridade == 42
      assert incidente.data_geracao == ~U[2024-07-01 22:48:00Z]
    end

    test "create_incidente/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EstruturasDeDados.create_incidente(@invalid_attrs)
    end

    test "update_incidente/2 with valid data updates the incidente" do
      incidente = incidente_fixture()
      update_attrs = %{descricao: "some updated descricao", situacao: :Solucionando, observacao: "some updated observacao", impacto: :Baixo, prioridade: 43, data_geracao: ~U[2024-07-02 22:48:00Z]}

      assert {:ok, %Incidente{} = incidente} = EstruturasDeDados.update_incidente(incidente, update_attrs)
      assert incidente.descricao == "some updated descricao"
      assert incidente.situacao == :Solucionando
      assert incidente.observacao == "some updated observacao"
      assert incidente.impacto == :Baixo
      assert incidente.prioridade == 43
      assert incidente.data_geracao == ~U[2024-07-02 22:48:00Z]
    end

    test "update_incidente/2 with invalid data returns error changeset" do
      incidente = incidente_fixture()
      assert {:error, %Ecto.Changeset{}} = EstruturasDeDados.update_incidente(incidente, @invalid_attrs)
      assert incidente == EstruturasDeDados.get_incidente!(incidente.id)
    end

    test "delete_incidente/1 deletes the incidente" do
      incidente = incidente_fixture()
      assert {:ok, %Incidente{}} = EstruturasDeDados.delete_incidente(incidente)
      assert_raise Ecto.NoResultsError, fn -> EstruturasDeDados.get_incidente!(incidente.id) end
    end

    test "change_incidente/1 returns a incidente changeset" do
      incidente = incidente_fixture()
      assert %Ecto.Changeset{} = EstruturasDeDados.change_incidente(incidente)
    end
  end

  describe "incidentes" do
    alias Rmm.EstruturasDeDados.Entidades.Incidente

    import Rmm.EstruturasDeDadosFixtures

    @invalid_attrs %{descricao: nil, situacao: nil, observacao: nil, impacto: nil, prioridade: nil, data_geracao: nil}

    test "list_incidentes/0 returns all incidentes" do
      incidente = incidente_fixture()
      assert EstruturasDeDados.list_incidentes() == [incidente]
    end

    test "get_incidente!/1 returns the incidente with given id" do
      incidente = incidente_fixture()
      assert EstruturasDeDados.get_incidente!(incidente.id) == incidente
    end

    test "create_incidente/1 with valid data creates a incidente" do
      valid_attrs = %{descricao: "some descricao", situacao: :Aberto, observacao: "some observacao", impacto: :Nenhum, prioridade: 42, data_geracao: ~U[2024-07-01 22:55:00Z]}

      assert {:ok, %Incidente{} = incidente} = EstruturasDeDados.create_incidente(valid_attrs)
      assert incidente.descricao == "some descricao"
      assert incidente.situacao == :Aberto
      assert incidente.observacao == "some observacao"
      assert incidente.impacto == :Nenhum
      assert incidente.prioridade == 42
      assert incidente.data_geracao == ~U[2024-07-01 22:55:00Z]
    end

    test "create_incidente/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EstruturasDeDados.create_incidente(@invalid_attrs)
    end

    test "update_incidente/2 with valid data updates the incidente" do
      incidente = incidente_fixture()
      update_attrs = %{descricao: "some updated descricao", situacao: :Solucionando, observacao: "some updated observacao", impacto: :Baixo, prioridade: 43, data_geracao: ~U[2024-07-02 22:55:00Z]}

      assert {:ok, %Incidente{} = incidente} = EstruturasDeDados.update_incidente(incidente, update_attrs)
      assert incidente.descricao == "some updated descricao"
      assert incidente.situacao == :Solucionando
      assert incidente.observacao == "some updated observacao"
      assert incidente.impacto == :Baixo
      assert incidente.prioridade == 43
      assert incidente.data_geracao == ~U[2024-07-02 22:55:00Z]
    end

    test "update_incidente/2 with invalid data returns error changeset" do
      incidente = incidente_fixture()
      assert {:error, %Ecto.Changeset{}} = EstruturasDeDados.update_incidente(incidente, @invalid_attrs)
      assert incidente == EstruturasDeDados.get_incidente!(incidente.id)
    end

    test "delete_incidente/1 deletes the incidente" do
      incidente = incidente_fixture()
      assert {:ok, %Incidente{}} = EstruturasDeDados.delete_incidente(incidente)
      assert_raise Ecto.NoResultsError, fn -> EstruturasDeDados.get_incidente!(incidente.id) end
    end

    test "change_incidente/1 returns a incidente changeset" do
      incidente = incidente_fixture()
      assert %Ecto.Changeset{} = EstruturasDeDados.change_incidente(incidente)
    end
  end

  describe "incidentes" do
    alias Rmm.EstruturasDeDados.Entidades.Incidente

    import Rmm.EstruturasDeDadosFixtures

    @invalid_attrs %{descricao: nil, situacao: nil, observacao: nil, impacto: nil, prioridade: nil, data_geracao: nil}

    test "list_incidentes/0 returns all incidentes" do
      incidente = incidente_fixture()
      assert EstruturasDeDados.list_incidentes() == [incidente]
    end

    test "get_incidente!/1 returns the incidente with given id" do
      incidente = incidente_fixture()
      assert EstruturasDeDados.get_incidente!(incidente.id) == incidente
    end

    test "create_incidente/1 with valid data creates a incidente" do
      valid_attrs = %{descricao: "some descricao", situacao: :Aberto, observacao: "some observacao", impacto: :Nenhum, prioridade: 42, data_geracao: ~U[2024-07-01 22:56:00Z]}

      assert {:ok, %Incidente{} = incidente} = EstruturasDeDados.create_incidente(valid_attrs)
      assert incidente.descricao == "some descricao"
      assert incidente.situacao == :Aberto
      assert incidente.observacao == "some observacao"
      assert incidente.impacto == :Nenhum
      assert incidente.prioridade == 42
      assert incidente.data_geracao == ~U[2024-07-01 22:56:00Z]
    end

    test "create_incidente/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EstruturasDeDados.create_incidente(@invalid_attrs)
    end

    test "update_incidente/2 with valid data updates the incidente" do
      incidente = incidente_fixture()
      update_attrs = %{descricao: "some updated descricao", situacao: :Solucionando, observacao: "some updated observacao", impacto: :Baixo, prioridade: 43, data_geracao: ~U[2024-07-02 22:56:00Z]}

      assert {:ok, %Incidente{} = incidente} = EstruturasDeDados.update_incidente(incidente, update_attrs)
      assert incidente.descricao == "some updated descricao"
      assert incidente.situacao == :Solucionando
      assert incidente.observacao == "some updated observacao"
      assert incidente.impacto == :Baixo
      assert incidente.prioridade == 43
      assert incidente.data_geracao == ~U[2024-07-02 22:56:00Z]
    end

    test "update_incidente/2 with invalid data returns error changeset" do
      incidente = incidente_fixture()
      assert {:error, %Ecto.Changeset{}} = EstruturasDeDados.update_incidente(incidente, @invalid_attrs)
      assert incidente == EstruturasDeDados.get_incidente!(incidente.id)
    end

    test "delete_incidente/1 deletes the incidente" do
      incidente = incidente_fixture()
      assert {:ok, %Incidente{}} = EstruturasDeDados.delete_incidente(incidente)
      assert_raise Ecto.NoResultsError, fn -> EstruturasDeDados.get_incidente!(incidente.id) end
    end

    test "change_incidente/1 returns a incidente changeset" do
      incidente = incidente_fixture()
      assert %Ecto.Changeset{} = EstruturasDeDados.change_incidente(incidente)
    end
  end

  describe "solucoes_contorno" do
    alias Rmm.EstruturasDeDados.Entidades.SolucaoContorno

    import Rmm.EstruturasDeDadosFixtures

    @invalid_attrs %{descricao: nil, situacao: nil, solucao: nil}

    test "list_solucoes_contorno/0 returns all solucoes_contorno" do
      solucao_contorno = solucao_contorno_fixture()
      assert EstruturasDeDados.list_solucoes_contorno() == [solucao_contorno]
    end

    test "get_solucao_contorno!/1 returns the solucao_contorno with given id" do
      solucao_contorno = solucao_contorno_fixture()
      assert EstruturasDeDados.get_solucao_contorno!(solucao_contorno.id) == solucao_contorno
    end

    test "create_solucao_contorno/1 with valid data creates a solucao_contorno" do
      valid_attrs = %{descricao: "some descricao", situacao: :Ativo, solucao: "some solucao"}

      assert {:ok, %SolucaoContorno{} = solucao_contorno} = EstruturasDeDados.create_solucao_contorno(valid_attrs)
      assert solucao_contorno.descricao == "some descricao"
      assert solucao_contorno.situacao == :Ativo
      assert solucao_contorno.solucao == "some solucao"
    end

    test "create_solucao_contorno/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EstruturasDeDados.create_solucao_contorno(@invalid_attrs)
    end

    test "update_solucao_contorno/2 with valid data updates the solucao_contorno" do
      solucao_contorno = solucao_contorno_fixture()
      update_attrs = %{descricao: "some updated descricao", situacao: :Inativo, solucao: "some updated solucao"}

      assert {:ok, %SolucaoContorno{} = solucao_contorno} = EstruturasDeDados.update_solucao_contorno(solucao_contorno, update_attrs)
      assert solucao_contorno.descricao == "some updated descricao"
      assert solucao_contorno.situacao == :Inativo
      assert solucao_contorno.solucao == "some updated solucao"
    end

    test "update_solucao_contorno/2 with invalid data returns error changeset" do
      solucao_contorno = solucao_contorno_fixture()
      assert {:error, %Ecto.Changeset{}} = EstruturasDeDados.update_solucao_contorno(solucao_contorno, @invalid_attrs)
      assert solucao_contorno == EstruturasDeDados.get_solucao_contorno!(solucao_contorno.id)
    end

    test "delete_solucao_contorno/1 deletes the solucao_contorno" do
      solucao_contorno = solucao_contorno_fixture()
      assert {:ok, %SolucaoContorno{}} = EstruturasDeDados.delete_solucao_contorno(solucao_contorno)
      assert_raise Ecto.NoResultsError, fn -> EstruturasDeDados.get_solucao_contorno!(solucao_contorno.id) end
    end

    test "change_solucao_contorno/1 returns a solucao_contorno changeset" do
      solucao_contorno = solucao_contorno_fixture()
      assert %Ecto.Changeset{} = EstruturasDeDados.change_solucao_contorno(solucao_contorno)
    end
  end
end
