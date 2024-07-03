defmodule Rmm.EstruturasDeDados.Entidades.Incidente do
  use Ecto.Schema
  import Ecto.Changeset

  schema "incidentes" do
    field :descricao, :string
    field :situacao, Ecto.Enum, values: [:Aberto, :Solucionando, :Solucionado]
    field :observacao, :string
    field :impacto, Ecto.Enum, values: [:Nenhum, :Baixo, :Médio, :Alto, :Altíssimo]
    field :prioridade, :integer
    field :data_geracao, :utc_datetime

    belongs_to :itens_configuracao, Rmm.ItemConfiguracao, foreign_key: :codigo_item_configuracao
    belongs_to :solucoes_contorno, Rmm.SolucaoContorno, foreign_key: :codigo_solucao_contorno
    belongs_to :regras_eventos_criticidade, Rmm.RegraEventoCriticidade, foreign_key: :codigo_regra_evento_criticidade

    timestamps()
  end

  @doc false
  def changeset(incidente, attrs) do
    incidente
    |> cast(attrs, [:descricao, :situacao, :observacao, :impacto, :prioridade, :data_geracao, :codigo_item_configuracao, :codigo_solucao_contorno, :codigo_regra_evento_criticidade])
    |> validate_required([:descricao, :situacao, :observacao, :impacto, :prioridade, :data_geracao])
  end
end
