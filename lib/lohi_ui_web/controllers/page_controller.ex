defmodule LohiUiWeb.PageController do
  alias LohiUi.Admin

  use LohiUiWeb, :controller

  def index(conn, _params) do
    playlists = Admin.list_playlists()
    render conn, "index.html", playlists: playlists
  end
end
