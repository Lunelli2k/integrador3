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
end
