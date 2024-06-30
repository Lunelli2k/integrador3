defmodule RmmWeb.ItemConfiguracaoHTML do
  use RmmWeb, :html

  embed_templates "item_configuracao_html/*"

  @doc """
  Renders a item_configuracao form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def item_configuracao_form(assigns)
end
