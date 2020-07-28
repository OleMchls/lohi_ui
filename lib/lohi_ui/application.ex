defmodule LohiUi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      {Phoenix.PubSub, [name: LohiUi.PubSub, adapter: Phoenix.PubSub.PG2]},
      LohiUiWeb.Endpoint,
      LohiUi.Player,
      LohiUi.MpdMonitor,
      LohiUi.Sync.Tftp,
      {LohiUi.Sync,
       [
         music_dir: Application.get_env(:lohi_ui, :music_directory),
         playlist_dir: Application.get_env(:lohi_ui, :playlist_directory)
       ]},
      # Starts a worker by calling: LohiUi.Worker.start_link(arg)
      # {LohiUi.Worker, arg},
      {Cluster.Supervisor, [Application.get_env(:libcluster, :topologies), [name: LohiUi.ClusterSupervisor]]}
    ]

    # unblock paracusia application start - to continue lohi app
    # boot order (which boots paracusia before mpd)
    spawn(Application, :start, [:paracusia])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LohiUi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    LohiUiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
