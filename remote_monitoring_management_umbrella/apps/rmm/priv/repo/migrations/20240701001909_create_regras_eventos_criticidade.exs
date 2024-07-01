defmodule Rmm.Repo.Migrations.CreateRegrasEventosCriticidade do
  use Ecto.Migration

  def change do
    create table(:regras_eventos_criticidade) do
      add :descricao, :string, size: 50, null: false
      add :tipo_evento_criticidade, :string, size: 50, null: false
      add :condicao, :string, size: 50, null: false
      add :propriedade_verificar, :string, size: 50, null: false
      add :valor_propriedade, :float, null: false
      add :prioridade, :integer, null: false
      add :impacto, :string, size: 50, null: false
      add :gera_incidente, :boolean, default: false, null: false
      add :item_configuracao_id, references(:itens_configuracao, on_delete: :nothing), null: false
      add :solucao_contorno_id, references(:solucoes_contorno, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:regras_eventos_criticidade, [:item_configuracao_id])
    create index(:regras_eventos_criticidade, [:solucao_contorno_id])
  end
end
