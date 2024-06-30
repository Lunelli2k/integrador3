defmodule Rmm.Repo.Migrations.CreateSolucoesContorno do
  use Ecto.Migration

  def change do
    create table(:solucoes_contorno) do
      add :codigo, :integer
      add :descricao, :text
      add :situacao, :string
      add :solucao, :text

      timestamps()
    end
  end
end
