defmodule LohiUi.Player do
  use GenServer

  @initial_volume 20

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init_player() do
    GenServer.call(__MODULE__, :init_player)
  end

  def play(uuid) do
    Paracusia.MpdClient.Playback.stop()
    Paracusia.MpdClient.Queue.clear()
    Paracusia.MpdClient.Playlists.load("#{uuid}")
    Paracusia.MpdClient.Playback.play()
  end

  def play() do
    (Paracusia.PlayerState.status().state == :play)
    |> Paracusia.MpdClient.Playback.pause()
  end

  def skip() do
    Paracusia.MpdClient.Playback.next()
  end

  def volume_up(step) do
    min(Paracusia.PlayerState.status().volume + step, 100)
    |> Paracusia.MpdClient.Playback.set_volume()
  end

  def volume_down(step) do
    max(Paracusia.PlayerState.status().volume - step, 0)
    |> Paracusia.MpdClient.Playback.set_volume()
  end

  def handle_call(:init_player, _from, state) do
    Paracusia.MpdClient.Playback.stop()
    Paracusia.MpdClient.Queue.clear()
    Paracusia.MpdClient.Playback.set_volume(@initial_volume)

    {mod, fun, args} = Application.get_env(:lohi_ui, :load_callback, {IO, :inspect, ["no init fn provided"]})

    {:reply, :ok, apply(mod, fun, args)}
  end
end
