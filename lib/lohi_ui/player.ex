defmodule LohiUi.Player do
  use GenServer

  @initial_volume 20
  @playcount_key "loonie-pc"

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

  def playcount(file) do
    Paracusia.MpdClient.Stickers.get(file, @playcount_key)
    |> case do
      {:ok, count} -> String.to_integer(count)
      {:error, _} -> 0
    end
  end

  def handle_call(:init_player, _from, state) do
    Paracusia.PlayerState.subscribe(self())

    Paracusia.MpdClient.Playback.stop()
    Paracusia.MpdClient.Queue.clear()
    Paracusia.MpdClient.Playback.set_volume(@initial_volume)

    {mod, fun, args} = Application.get_env(:lohi_ui, :load_callback, {IO, :inspect, ["no init fn provided"]})

    {:reply, :ok, apply(mod, fun, args)}
  end

  def handle_info(
        {:paracusia,
         {:player_changed,
          %Paracusia.PlayerState{
            current_song: %{"file" => file},
            status: %Paracusia.PlayerState.Status{elapsed: elapsed}
          } = player_state} = event},
        state
      )
      when elapsed != 0 do
    Paracusia.MpdClient.Stickers.set(file, @playcount_key, playcount(file) + 1)

    {:noreply, state}
  end

  def handle_info({:paracusia, event}, state) do
    {:noreply, state}
  end
end
