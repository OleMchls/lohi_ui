require Logger

defmodule LohiUi.Sync.Trigger do
  use GenServer

  # 2 minutes
  @interval 120_000

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    schedule_sync()
    {:ok, opts}
  end

  def trigger_sync do
    GenServer.cast(__MODULE__, :trigger)
  end

  @impl true
  def handle_cast(:trigger, state) do
    schedule_sync(0)
    {:noreply, state}
  end

  @impl true
  def handle_info(:sync, state) do
    Node.list()
    |> Enum.map(&sync_node/1)

    schedule_sync(@interval)
    {:noreply, state}
  end

  defp schedule_sync(interval) do
    Process.send_after(self(), :sync, interval)
  end

  defp sync_node(node) do
    Logger.info("Starting sycing with #{node}")
    {:ok, songs: songs, playlists: playlists} = LohiUi.Sync.sync(node)

    Logger.info("Syning with #{node} completed.")
    Logger.info("#{songs} Songs added. #{playlists} playlists added.")
    Logger.info("Rescanning mpd db now...")

    if playlists > 0 do
      LohiUi.Callbacks.success()
    end

    LohiUi.Admin.rescan()

    Logger.info("Done resyncing mdp database.")
  end
end
