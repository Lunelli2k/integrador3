defmodule RmmWeb.IncidenteHTML do
  use RmmWeb, :html

  embed_templates "incidente_html/*"

  @doc """
  Renders a incidente form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def incidente_form(assigns)
end
