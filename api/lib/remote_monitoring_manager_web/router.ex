defmodule RemoteMonitoringManagerWeb.Router do
  use RemoteMonitoringManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RemoteMonitoringManagerWeb do
    pipe_through :api
    get "/", DefaultController, :index
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: RemoteMonitoringManagerWeb.Telemetry
    end

  end
end
