defmodule Rmm.EstruturasDeDadosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rmm.EstruturasDeDados` context.
  """

  @doc """
  Generate a incidente.
  """
  def incidente_fixture(attrs \\ %{}) do
    {:ok, incidente} =
      attrs
      |> Enum.into(%{
        data_geracao: ~U[2024-07-01 22:48:00Z],
        descricao: "some descricao",
        impacto: :Nenhum,
        observacao: "some observacao",
        prioridade: 42,
        situacao: :Aberto
      })
      |> Rmm.EstruturasDeDados.create_incidente()

    incidente
  end

  @doc """
  Generate a incidente.
  """
  def incidente_fixture(attrs \\ %{}) do
    {:ok, incidente} =
      attrs
      |> Enum.into(%{
        data_geracao: ~U[2024-07-01 22:55:00Z],
        descricao: "some descricao",
        impacto: :Nenhum,
        observacao: "some observacao",
        prioridade: 42,
        situacao: :Aberto
      })
      |> Rmm.EstruturasDeDados.create_incidente()

    incidente
  end

  @doc """
  Generate a incidente.
  """
  def incidente_fixture(attrs \\ %{}) do
    {:ok, incidente} =
      attrs
      |> Enum.into(%{
        data_geracao: ~U[2024-07-01 22:56:00Z],
        descricao: "some descricao",
        impacto: :Nenhum,
        observacao: "some observacao",
        prioridade: 42,
        situacao: :Aberto
      })
      |> Rmm.EstruturasDeDados.create_incidente()

    incidente
  end

  @doc """
  Generate a solucao_contorno.
  """
  def solucao_contorno_fixture(attrs \\ %{}) do
    {:ok, solucao_contorno} =
      attrs
      |> Enum.into(%{
        descricao: "some descricao",
        situacao: :Ativo,
        solucao: "some solucao"
      })
      |> Rmm.EstruturasDeDados.create_solucao_contorno()

    solucao_contorno
  end
end
