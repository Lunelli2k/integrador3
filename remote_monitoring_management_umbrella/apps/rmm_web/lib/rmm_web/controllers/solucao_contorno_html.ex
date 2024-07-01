defmodule RmmWeb.SolucaoContornoHTML do
  use RmmWeb, :html

  embed_templates "solucao_contorno_html/*"

  @doc """
  Renders a solucao_contorno form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def solucao_contorno_form(assigns)
end
