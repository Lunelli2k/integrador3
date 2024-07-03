defmodule Rmm.EstruturasDeDados.EntidadesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rmm.EstruturasDeDados.Entidades` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Rmm.EstruturasDeDados.Entidades.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  @doc """
  Generate a item_configuracao.
  """
  def item_configuracao_fixture(attrs \\ %{}) do
    {:ok, item_configuracao} =
      attrs
      |> Enum.into(%{
        capacidade_gb: 42,
        categoria: :CPU,
        codigo_integracao: "some codigo_integracao",
        descricao: "some descricao",
        fabricante: "some fabricante",
        frequencia_mhz: 42,
        marca: "some marca",
        nucleos: 42,
        porcentagem_uso: 120.5,
        situacao: :Ativo,
        temperatura: 120.5,
        tipo: "some tipo"
      })
      |> Rmm.EstruturasDeDados.Entidades.create_item_configuracao()

    item_configuracao
  end

  @doc """
  Generate a solucao_contorno.
  """
  def solucao_contorno_fixture(attrs \\ %{}) do
    {:ok, solucao_contorno} =
      attrs
      |> Enum.into(%{
        codigo: 42,
        descricao: "some descricao",
        situacao: :Ativo,
        solucao: "some solucao"
      })
      |> Rmm.EstruturasDeDados.Entidades.create_solucao_contorno()

    solucao_contorno
  end

  @doc """
  Generate a incidente.
  """
  def incidente_fixture(attrs \\ %{}) do
    {:ok, incidente} =
      attrs
      |> Enum.into(%{
        codigo: 42,
        codigo_item_configuracao: 42,
        codigo_regra_evento_criticidade: 42,
        codigo_solucao_contorno: 42,
        data_geracao: ~U[2024-06-29 15:02:00Z],
        descricao: "some descricao",
        impacto: :Nenhum,
        observacao: "some observacao",
        prioridade: 42,
        situacao: :Aberto
      })
      |> Rmm.EstruturasDeDados.Entidades.create_incidente()

    incidente
  end

  @doc """
  Generate a regra_evento_criticidade.
  """
  def regra_evento_criticidade_fixture(attrs \\ %{}) do
    {:ok, regra_evento_criticidade} =
      attrs
      |> Enum.into(%{
        condicao: :Maior,
        descricao: "some descricao",
        impacto: :Nenhum,
        prioridade: 42,
        propriedade_verificar: :Temperatura,
        tipo_evento_criticidade: :Falha,
        valor_propriedade: 120.5
      })
      |> Rmm.EstruturasDeDados.Entidades.create_regra_evento_criticidade()

    regra_evento_criticidade
  end

  @doc """
  Generate a regra_evento_criticidade.
  """
  def regra_evento_criticidade_fixture(attrs \\ %{}) do
    {:ok, regra_evento_criticidade} =
      attrs
      |> Enum.into(%{
        condicao: :Maior,
        descricao: "some descricao",
        gera_incidente: true,
        impacto: :Nenhum,
        prioridade: 42,
        propriedade_verificar: :Temperatura,
        tipo_evento_criticidade: :Falha,
        valor_propriedade: 120.5
      })
      |> Rmm.EstruturasDeDados.Entidades.create_regra_evento_criticidade()

    regra_evento_criticidade
  end
end
