defmodule LohiUiWeb.PlaylistController do
  use LohiUiWeb, :controller

  alias LohiUi.Admin
  alias LohiUi.Admin.Playlist

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"tag" => tag, "files" => files}) do
    LohiUi.Admin.rescan()

    case Admin.create_playlist(tag, files) do
      :ok ->
        conn
        |> put_flash(:info, "Playlist created successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.playlist_path(conn, :new))
    end
  end

  def upload(conn, %{"file" => %Plug.Upload{} = upload}) do
    music_path = Application.get_env(:lohi_ui, :music_directory)
    File.copy!(upload.path, "#{music_path}/#{upload.filename}")
    json(conn, %{success: true, name: upload.filename})
  end

  def show(conn, %{"id" => id}) do
    # playlist = Admin.get_playlist!(id)
    # render(conn, "show.html", playlist: playlist)
  end

  def edit(conn, %{"id" => id}) do
    # playlist = Admin.get_playlist!(id)
    # changeset = Admin.change_playlist(playlist)
    # render(conn, "edit.html", playlist: playlist, changeset: changeset)
  end

  def update(conn, %{"id" => id, "playlist" => playlist_params}) do
    # playlist = Admin.get_playlist!(id)
    #
    # case Admin.update_playlist(playlist, playlist_params) do
    #   {:ok, playlist} ->
    #     conn
    #     |> put_flash(:info, "Playlist updated successfully.")
    #     |> redirect(to: Routes.playlist_path(conn, :show, playlist))
    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "edit.html", playlist: playlist, changeset: changeset)
    # end
  end

  def delete(conn, %{"id" => id}) do
    :ok =
      Admin.get_playlist(id)
      |> Admin.delete_playlist()

    conn
    |> put_flash(:info, "Playlist deleted successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
