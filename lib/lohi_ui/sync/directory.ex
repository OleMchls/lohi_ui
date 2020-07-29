defmodule LohiUi.Sync.Directory do
  use GenServer

  defmodule State do
    defstruct [:music_dir, :playlist_dir]
  end

  def start_link(default) do
    GenServer.start_link(__MODULE__, default, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    {:ok, %State{music_dir: Keyword.fetch!(opts, :music_dir), playlist_dir: Keyword.fetch!(opts, :playlist_dir)}}
  end

  def all_songs(node), do: GenServer.call({__MODULE__, node}, {:list, :music_dir})
  def songs_dir(node), do: GenServer.call({__MODULE__, node}, {:pwd, :music_dir})

  def all_playlists(node), do: GenServer.call({__MODULE__, node}, {:list, :playlist_dir})
  def playlists_dir(node), do: GenServer.call({__MODULE__, node}, {:pwd, :playlist_dir})

  defp list(path), do: File.ls!(path)

  @impl true
  def handle_call({:list, dir}, _from, state) do
    {:reply, list(Map.get(state, dir)), state}
  end

  def handle_call({:pwd, dir}, _from, state) do
    {:reply, Map.get(state, dir), state}
  end
end
