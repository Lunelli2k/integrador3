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
end
