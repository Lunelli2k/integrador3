defmodule RmmWeb.APIController do
  use RmmWeb, :controller

  def teste(conn, _params) do
    text conn, "Server is running at port 4000"
  end

  def enviar_estado(conn, params) do

    response = %{
      "data" => params
    }

    RmmWeb.Endpoint.broadcast("estado:updates", "new_data", params)

    json(conn, response)

  end

end
