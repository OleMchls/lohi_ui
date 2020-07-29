defmodule LohiUi.Sync do
  use GenServer

  import LohiUi.Sync.Directory

  defmodule State do
    defstruct []
  end

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    {:ok, %State{}}
  end

  def sync(remote_node) do
    GenServer.call(__MODULE__, {:sync, remote_node}, :infinity)
  end

  def songs_missing_from_node(remote_node) do
    diff(all_songs(node()), all_songs(remote_node))
  end

  def playlists_missing_from_node(remote_node) do
    diff(all_playlists(node()), all_playlists(remote_node))
  end

  defp diff(a, b) do
    MapSet.new(b)
    |> MapSet.difference(MapSet.new(a))
    |> MapSet.to_list()
  end

  # Callbacks

  @impl true
  def handle_call({:sync, remote_node}, _from, state) do
    remote_song_dir = songs_dir(remote_node)
    local_song_dir = songs_dir(node())

    remote_playlist_dir = playlists_dir(remote_node)
    local_playlist_dir = playlists_dir(node())

    missing_songs = songs_missing_from_node(remote_node)
    missing_playlists = playlists_missing_from_node(remote_node)

    [_remote_node_name, remote_host] = Atom.to_string(remote_node) |> String.split("@")
    tftp_opts = [host: String.to_charlist(remote_host)]

    Enum.map(missing_songs, fn song ->
      Task.async(fn ->
        LohiUi.Sync.Tftp.read_file("#{remote_song_dir}/#{song}", "#{local_song_dir}/#{song}", tftp_opts)
      end)
    end)
    |> Enum.map(&Task.await(&1, :infinity))

    Enum.map(missing_playlists, fn playlist ->
      Task.async(fn ->
        LohiUi.Sync.Tftp.read_file("#{remote_playlist_dir}/#{playlist}", "#{local_playlist_dir}/#{playlist}", tftp_opts)
      end)
    end)
    |> Enum.map(&Task.await(&1, :infinity))

    {:reply, {:ok, songs: length(missing_songs), playlists: length(missing_playlists)}, state}
  end
end
