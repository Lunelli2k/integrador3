defmodule Rmm.EstruturasDeDados.Entidades.RegraEventoCriticidade do
  use Ecto.Schema
  import Ecto.Changeset

  schema "regras_eventos_criticidade" do
    field :descricao, :string
    field :tipo_evento_criticidade, Ecto.Enum, values: [:Falha, :Alerta]
    field :condicao, Ecto.Enum, values: [:Maior, :Igual, :Menor]
    field :propriedade_verificar, Ecto.Enum, values: [:Temperatura, :"Porcentagem de Uso"]
    field :valor_propriedade, :float
    field :prioridade, :integer
    field :impacto, Ecto.Enum, values: [:Nenhum, :Baixo, :Médio, :Alto, :Altíssimo]
    field :gera_incidente, :boolean, default: false
    field :item_configuracao_id, :id
    field :solucao_contorno_id, :id

    timestamps()
  end

  @doc false
  def changeset(regra_evento_criticidade, attrs) do
    regra_evento_criticidade
    |> cast(attrs, [:descricao, :tipo_evento_criticidade, :condicao, :propriedade_verificar, :valor_propriedade, :prioridade, :impacto, :gera_incidente])
    |> validate_required([:descricao, :tipo_evento_criticidade, :condicao, :propriedade_verificar, :valor_propriedade, :prioridade, :impacto, :gera_incidente])
  end
end
