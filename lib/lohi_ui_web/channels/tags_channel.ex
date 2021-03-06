defmodule LohiUiWeb.TagsChannel do
  use LohiUiWeb, :channel

  def broadcast_tag(uuid) do
    LohiUiWeb.Endpoint.broadcast!("tags:lobby", "tag", %{tag: uuid})
  end

  def broadcast_player_state(state) do
    LohiUiWeb.Endpoint.broadcast!("tags:lobby", "player", %{player: state})
  end

  def join("tags:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (tags:lobby).
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  def handle_in("ctrl", %{"action" => "tag", "tag" => uuid}, socket) do
    LohiUi.Controls.tag(uuid)

    {:noreply, socket}
  end

  def handle_in("ctrl", %{"action" => "max_volume", "max" => max}, socket) do
    String.to_integer(max)
    |> LohiUi.Player.max_volume()

    {:noreply, socket}
  end

  def handle_in("ctrl", %{"action" => action}, socket) do
    case action do
      "play" -> LohiUi.Controls.play()
      "skip" -> LohiUi.Controls.skip()
      "vol_up" -> LohiUi.Controls.volume_up()
      "vol_down" -> LohiUi.Controls.volume_down()
    end

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
