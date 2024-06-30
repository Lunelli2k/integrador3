defmodule Rmm.Repo.Migrations.CreateItensConfiguracao do
  use Ecto.Migration

  def change do
    create table(:itens_configuracao) do
      add :descricao, :string, size: 50, null: false
      add :fabricante, :string, size: 50
      add :marca, :string, size: 50
      add :porcentagem_uso, :float
      add :temperatura, :float
      add :situacao, :string, size: 50, null: false
      add :capacidade_gb, :integer
      add :tipo, :string, size: 50
      add :nucleos, :integer
      add :frequencia_mhz, :integer
      add :categoria, :string, size: 50, null: false
      add :codigo_integracao, :string, size: 50, null: false

      timestamps()
    end
  end
end
