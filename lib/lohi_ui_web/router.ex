defmodule LohiUiWeb.Router do
  use LohiUiWeb, :router

  pipeline :browser do
    plug(:accepts, ["html", "json"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", LohiUiWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    resources("/playlists", PlaylistController)
  end

  scope "/media", LohiUiWeb do
    pipe_through(:api)

    post("/", PlaylistController, :upload)
  end

  # Other scopes may use custom stacks.
  # scope "/api", LohiUiWeb do
  #   pipe_through :api
  # end
end
