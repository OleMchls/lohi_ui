defmodule LohiUi.Controls do

  @step 15

  def tag(uuid) do
    LohiUiWeb.TagsChannel.broadcast_tag(uuid)
    LohiUi.Player.play(uuid)
  end

  def play do
    LohiUi.Player.play()
  end

  def volume_up do
    LohiUi.Player.volume_up(@step)
  end

  def volume_down do
    LohiUi.Player.volume_down(@step)
  end

end
