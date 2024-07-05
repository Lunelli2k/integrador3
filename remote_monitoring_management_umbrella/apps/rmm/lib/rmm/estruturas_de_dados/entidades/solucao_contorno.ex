defmodule Rmm.EstruturasDeDados.Entidades.SolucaoContorno do
  use Ecto.Schema
  import Ecto.Changeset

  schema "solucoes_contorno" do
    field :descricao, :string
    field :situacao, Ecto.Enum, values: [:Ativo, :Inativo]
    field :solucao, :string

    timestamps()
  end

  @doc false
  def changeset(solucao_contorno, attrs) do
    solucao_contorno
    |> cast(attrs, [:descricao, :situacao, :solucao])
    |> validate_required([:descricao, :situacao, :solucao])
  end
end
