defmodule RemoteMonitoringManagerWeb.DefaultController do
  use RemoteMonitoringManagerWeb, :controller



  def index(conn, _params) do
    text conn, "Server is running at port 4000"
  end

end
