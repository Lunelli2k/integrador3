defmodule Rmm.EstruturasDeDados.Entidades.Incidente do
  use Ecto.Schema
  import Ecto.Changeset

  schema "incidentes" do
    field :codigo, :integer
    field :descricao, :string
    field :codigo_item_configuracao, :integer
    field :codigo_solucao_contorno, :integer
    field :situacao, Ecto.Enum, values: [:Aberto, :Solucionando, :Solucionado]
    field :observacao, :string
    field :impacto, Ecto.Enum, values: [:Nenhum, :Baixo, :Medio, :Alto, :Altissimo]
    field :prioridade, :integer
    field :codigo_regra_evento_criticidade, :integer
    field :data_geracao, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(incidente, attrs) do
    incidente
    |> cast(attrs, [:codigo, :descricao, :codigo_item_configuracao, :codigo_solucao_contorno, :situacao, :observacao, :impacto, :prioridade, :codigo_regra_evento_criticidade, :data_geracao])
    |> validate_required([:codigo, :descricao, :codigo_item_configuracao, :codigo_solucao_contorno, :situacao, :observacao, :impacto, :prioridade, :codigo_regra_evento_criticidade, :data_geracao])
  end
end
