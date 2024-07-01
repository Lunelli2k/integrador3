defmodule RmmWeb.RegraEventoCriticidadeHTML do
  use RmmWeb, :html

  embed_templates "regra_evento_criticidade_html/*"

  @doc """
  Renders a regra_evento_criticidade form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def regra_evento_criticidade_form(assigns)
end
