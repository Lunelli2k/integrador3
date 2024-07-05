defmodule RmmWeb.APIController do
  use RmmWeb, :controller
  alias Rmm.Repo

  alias Rmm.EstruturasDeDados.Entidades
  alias Rmm.EstruturasDeDados.Entidades.ItemConfiguracao
  alias Rmm.EstruturasDeDados.Entidades.RegraEventoCriticidade


  def teste(conn, _params) do
    text conn, "Server is running at port 4000"
  end

  def enviar_estado(conn, params) do
    RmmWeb.Endpoint.broadcast("estado:updates", "new_data", params)
    case Repo.get_by!(ItemConfiguracao, categoria: :CPU) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "IC not found"})

      data ->
        {:ok, _} = Entidades.update_item_configuracao(data, %{
          porcentagem_uso: Map.get(params, "processador_percentual"),
          temperatura: Map.get(params, "processador_temperatura"),
          capacidade_gb:
            Map.get(params, "memoria_capacidade")
              |> String.to_float()
              |> round(),
          tipo: "CPU",
          frequencia_mhz:
            Map.get(params, "processador_freq_atual")
              |> String.to_float()
              |> round()
          })
        if comparar_regras(params) do
          conn
          |> put_status(:ok)
          |> json(%{message: "Dados salvos"})
        else
          conn
          |> put_status(:unprocessable_entity)
          |> json(%{error: "Data comparison failed"})
        end
    end
    json(conn, "OK")
  end

  defp comparar_regras(_params) do
    true
  end
end
