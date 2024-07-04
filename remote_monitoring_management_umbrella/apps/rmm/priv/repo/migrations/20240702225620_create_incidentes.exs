defmodule Rmm.Repo.Migrations.CreateIncidentes do
  use Ecto.Migration

  def change do
    create table(:incidentes) do
      add :descricao, :text
      add :situacao, :string
      add :observacao, :text
      add :impacto, :string
      add :prioridade, :integer
      add :data_geracao, :utc_datetime
      add :codigo_item_configuracao, references(:itens_configuracao, on_delete: :nothing)
      add :codigo_solucao_contorno, references(:solucoes_contorno, on_delete: :nothing)
      add :codigo_regra_evento_criticidade, references(:regras_eventos_criticidade, on_delete: :nothing)

      timestamps()
    end

    create index(:incidentes, [:codigo_item_configuracao])
    create index(:incidentes, [:codigo_solucao_contorno])
    create index(:incidentes, [:codigo_regra_evento_criticidade])
  end
end
