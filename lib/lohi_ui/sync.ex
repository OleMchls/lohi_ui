defmodule LohiUi.Sync do
  use GenServer

  defmodule State do
    defstruct [:music_dir, :playlist_dir]
  end

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  def sync(node) do
    GenServer.call(__MODULE__, {:sync, node})
  end

  # :tftp.start([port: 19999])
  # :tftp.read_file("Procfile", :binary, [port: 19999])

  def all_songs, do: GenServer.call(__MODULE__, {:list, :music_dir})
  def all_songs(node), do: GenServer.call({__MODULE__, node}, {:list, :music_dir})

  def songs_missing_from_node(node) do
    diff(all_songs, all_songs(node))
  end

  defp diff(a, b) do
    MapSet.new(b)
    |> MapSet.difference(MapSet.new(a))
    |> MapSet.to_list()
  end

  defp list(path), do: File.ls!(path)

  # Callbacks

  @impl true
  def init(opts) do
    {:ok, %State{music_dir: Keyword.fetch!(opts, :music_dir), playlist_dir: Keyword.fetch!(opts, :playlist_dir)}}
  end

  @impl true
  def handle_call({:list, dir}, _from, state) do
    {:reply, list(Map.get(state, dir)), state}
  end

  def handle_call(:info, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:sync, node}, _from, state) do
    remote_sync = GenServer.call({__MODULE__, node}, :info)
    [_remote_node_name, remote_host] = Atom.to_string(node) |> String.split("@")

    missing_songs = diff(list(state.music_dir), all_songs(node))

    Enom.map(missing_songs, fn song ->
      LohiUi.Sync.Tftp.read_file("#{remote_sync.music_dir}/#{song}", "#{state.music_dir}/#{song}", host: remote_host)
    end)

    {:reply, {:ok, songs: length(missing_songs)}, state}
  end
end
