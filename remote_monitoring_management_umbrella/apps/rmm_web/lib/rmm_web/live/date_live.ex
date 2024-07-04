defmodule RmmWeb.DateLive do
  use RmmWeb, :live_view
  alias RmmWeb.APIController

  def mount(_params, _session, socket) do
    if connected?(socket), do: RmmWeb.Endpoint.subscribe("estado:updates")
    {:ok, assign(socket, :data, %{})}
  end

  def handle_info(%{event: "new_data", payload: data}, socket) do
    {:noreply, assign(socket, :data, data)}
  end

end
