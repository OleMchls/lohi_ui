defmodule LohiUi.Player do
  @initial_volume 20

  def init() do
    Paracusia.MpdClient.Playback.stop()
    Paracusia.MpdClient.Queue.clear()
    Paracusia.MpdClient.Playback.set_volume(@initial_volume)
    {mod, fun, args} = Application.get_env(:lohi_ui, :load_callback, {IO, :inspect, ["no init fn provided"]})
    apply(mod, fun, args)
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
end
