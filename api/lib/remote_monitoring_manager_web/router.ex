defmodule RemoteMonitoringManagerWeb.Router do
  use RemoteMonitoringManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RemoteMonitoringManagerWeb do
    pipe_through :api
    get "/", DefaultController, :index
  end
end
