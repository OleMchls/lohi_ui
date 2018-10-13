defmodule LohiUi.MpdMonitor do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  # Callbacks

  @impl true
  def init(pin) do
    GenServer.cast(self(), :check)

    {:ok, :there_is_no_state}
  end

  def handle_info({:DOWN, ref, :process, object, reason}, state) do
    check()
    {:noreply, state}
  end

  def handle_cast(:check, state) do
    check()
    {:noreply, state}
  end

  defp check() do
    Process.whereis(Paracusia.PlayerState)
    |> check()
  end

  defp check(nil) do
    Process.sleep(100)

    check()
  end

  defp check(pid) do
    # start monitoring recheck on down
    _monitor = Process.monitor(pid)
    LohiUi.Player.init_player()
  end
end
