defmodule Rmm.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Rmm.Repo,
      {DNSCluster, query: Application.get_env(:rmm, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Rmm.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Rmm.Finch}
      # Start a worker by calling: Rmm.Worker.start_link(arg)
      # {Rmm.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Rmm.Supervisor)
  end
end
