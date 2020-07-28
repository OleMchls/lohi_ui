require Logger

defmodule LohiUi.Callbacks do
  def boot do
    Application.get_env(:lohi_ui, :load_callback, fn -> Logger.info("no init fn provided") end).()
  end

  def volume_change(volume) do
    Application.get_env(:lohi_ui, :volume_change_callback, &Logger.info("Volume Change Callback #{&1}")).(volume)
  end

  def success do
    Application.get_env(:lohi_ui, :success_callback, fn -> Logger.info("success callback") end).()
  end
end
