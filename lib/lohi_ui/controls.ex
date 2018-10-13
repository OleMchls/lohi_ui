require Logger

defmodule LohiUi.Controls do
  @step 5

  def tag(uuid) do
    Logger.debug("Controls received TAG #{uuid}")
    LohiUiWeb.TagsChannel.broadcast_tag(uuid)
    LohiUi.Player.play(uuid)
  end

  def play do
    Logger.debug("Controls received PLAY")
    LohiUi.Player.play()
  end

  def skip do
    Logger.debug("Controls received SKIP")
    LohiUi.Player.skip()
  end

  def volume_up do
    Logger.debug("Controls received VOLUME UP")
    LohiUi.Player.volume_up(@step)
  end

  def volume_down do
    Logger.debug("Controls received VOLUME DOWN")
    LohiUi.Player.volume_down(@step)
  end
end
