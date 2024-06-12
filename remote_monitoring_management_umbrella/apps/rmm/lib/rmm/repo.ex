defmodule Rmm.Repo do
  use Ecto.Repo,
    otp_app: :rmm,
    adapter: Ecto.Adapters.Postgres
end
