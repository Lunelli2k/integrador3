defmodule Rmm.EstruturasDeDados.Entidades.ItemConfiguracao do
  use Ecto.Schema
  import Ecto.Changeset

  schema "itens_configuracao" do
    field :descricao, :string
    field :fabricante, :string
    field :marca, :string
    field :porcentagem_uso, :float
    field :temperatura, :float
    field :situacao, Ecto.Enum, values: [:Ativo, :Inativo]
    field :capacidade_gb, :integer
    field :tipo, :string
    field :nucleos, :integer
    field :frequencia_mhz, :integer
    field :categoria, Ecto.Enum, values: [:CPU, :"Memória Principal", :"Memória Secundária"]
    field :codigo_integracao, :string

    timestamps()
  end

  @doc false
  def changeset(item_configuracao, attrs) do
    item_configuracao
    |> cast(attrs, [:descricao, :fabricante, :marca, :porcentagem_uso, :temperatura, :situacao, :capacidade_gb, :tipo, :nucleos, :frequencia_mhz, :categoria, :codigo_integracao])
    |> validate_required([:descricao, :fabricante, :marca, :porcentagem_uso, :temperatura, :situacao, :capacidade_gb, :tipo, :nucleos, :frequencia_mhz, :categoria, :codigo_integracao])
  end
end
