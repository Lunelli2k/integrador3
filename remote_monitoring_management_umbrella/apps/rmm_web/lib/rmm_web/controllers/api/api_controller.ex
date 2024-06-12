defmodule RmmWeb.APIController do
  use RmmWeb, :controller

  def teste(conn, _params) do
    text conn, "Server is running at port 4000"
  end

  def enviar_estado(conn, params) do
    IO.inspect(params)

    response = %{
      "data" => params
    }

    json(conn, response)

  end

end
