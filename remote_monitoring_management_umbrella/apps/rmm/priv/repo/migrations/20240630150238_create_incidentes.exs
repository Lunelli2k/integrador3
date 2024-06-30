defmodule Rmm.Repo.Migrations.CreateIncidentes do
  use Ecto.Migration

  def change do
    create table(:incidentes) do
      add :codigo, :integer
      add :descricao, :text
      add :codigo_item_configuracao, :integer
      add :codigo_solucao_contorno, :integer
      add :situacao, :string
      add :observacao, :text
      add :impacto, :string
      add :prioridade, :integer
      add :codigo_regra_evento_criticidade, :integer
      add :data_geracao, :utc_datetime

      timestamps()
    end
  end
end
