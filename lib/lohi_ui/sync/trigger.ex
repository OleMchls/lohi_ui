require Logger

defmodule LohiUi.Sync.Trigger do
  use GenServer

  # 10 minutes
  @interval 600_000

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    schedule_trigger()
    {:ok, opts}
  end

  def trigger do
    GenServer.cast(__MODULE__, :trigger)
  end

  @impl true
  def handle_cast(:trigger, state) do
    Node.list()
    |> Enum.map(&sync_node/1)

    schedule_trigger()
    {:noreply, state}
  end

  defp schedule_trigger do
    Process.send_after(self(), :trigger, @interval)
  end

  defp sync_node(node) do
    Logger.info("Starting sycing with #{node}")
    {:ok, songs: songs, playlists: playlists} = LohiUi.Sync.sync(node)

    Logger.info(
      "Syning with #{node} completed. #{songs} Songs added. #{playlists} playlists added. Rescanning mpd db now..."
    )

    LohiUi.Admin.rescan()
    Logger.info("Done resyncing mdp database.")
  end
end
