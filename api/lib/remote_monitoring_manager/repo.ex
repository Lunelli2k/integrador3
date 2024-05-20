defmodule RemoteMonitoringManager.Repo do
  use Ecto.Repo,
    otp_app: :remote_monitoring_manager,
    adapter: Ecto.Adapters.Postgres
end
