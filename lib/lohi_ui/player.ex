defmodule LohiUi.Player do
  use GenServer

  @initial_volume 60
  @playcount_key "loonie-pc"

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def init_player() do
    GenServer.call(__MODULE__, :init_player)
  end

  def play(uuid) do
    case Paracusia.MpdClient.Playlists.list("#{uuid}") do
      {:ok, _} ->
        Paracusia.MpdClient.Playback.stop()
        Paracusia.MpdClient.Queue.clear()
        Paracusia.MpdClient.Playlists.load("#{uuid}")
        Paracusia.MpdClient.Playback.play()

      {:error, _} ->
        :ok
    end
  end

  def play() do
    (Paracusia.PlayerState.status().state == :play)
    |> Paracusia.MpdClient.Playback.pause()
  end

  def skip() do
    Paracusia.MpdClient.Playback.next()
  end

  def volume_up(step) do
    min(Paracusia.PlayerState.status().volume + step, max_volume)
    |> set_volume
  end

  def volume_down(step) do
    max(Paracusia.PlayerState.status().volume - step, 0)
    |> min(max_volume)
    |> set_volume
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

    LohiUi.Callbacks.boot()

    {:reply, :ok, state}
  end

  def handle_cast({:update, {_action, %Paracusia.PlayerState{} = player_state}}, state) do
    LohiUiWeb.TagsChannel.broadcast_player_state(Map.put(player_state, :max_volume, max_volume))

    {:noreply, state}
  end

  def handle_cast({:update, _}, state) do
    {:noreply, state}
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
    GenServer.cast(self(), {:update, event})

    {:noreply, state}
  end

  def handle_info({:paracusia, event}, state) do
    GenServer.cast(self(), {:update, event})
    {:noreply, state}
  end

  def max_volume(max) do
    Application.put_env(:lohi_ui, :max_volume, max)
    volume_down(0)
  end

  def max_volume, do: Application.get_env(:lohi_ui, :max_volume, 100)

  defp set_volume(vol) do
    LohiUi.Callbacks.volume_change(vol)
    Paracusia.MpdClient.Playback.set_volume(vol)
  end
end
