defmodule LohiUiWeb.PlaylistControllerTest do
  use LohiUiWeb.ConnCase

  alias LohiUi.Admin

  @create_attrs %{tag: "some tag"}
  @update_attrs %{tag: "some updated tag"}
  @invalid_attrs %{tag: nil}

  def fixture(:playlist) do
    {:ok, playlist} = Admin.create_playlist(@create_attrs)
    playlist
  end

  describe "index" do
    test "lists all playlists", %{conn: conn} do
      conn = get conn, Routes.playlist_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Playlists"
    end
  end

  describe "new playlist" do
    test "renders form", %{conn: conn} do
      conn = get conn, Routes.playlist_path(conn, :new)
      assert html_response(conn, 200) =~ "New Playlist"
    end
  end

  describe "create playlist" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, Routes.playlist_path(conn, :create), playlist: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.playlist_path(conn, :show, id)

      conn = get conn, Routes.playlist_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Playlist"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.playlist_path(conn, :create), playlist: @invalid_attrs
      assert html_response(conn, 200) =~ "New Playlist"
    end
  end

  describe "edit playlist" do
    setup [:create_playlist]

    test "renders form for editing chosen playlist", %{conn: conn, playlist: playlist} do
      conn = get conn, Routes.playlist_path(conn, :edit, playlist)
      assert html_response(conn, 200) =~ "Edit Playlist"
    end
  end

  describe "update playlist" do
    setup [:create_playlist]

    test "redirects when data is valid", %{conn: conn, playlist: playlist} do
      conn = put conn, Routes.playlist_path(conn, :update, playlist), playlist: @update_attrs
      assert redirected_to(conn) == Routes.playlist_path(conn, :show, playlist)

      conn = get conn, Routes.playlist_path(conn, :show, playlist)
      assert html_response(conn, 200) =~ "some updated tag"
    end

    test "renders errors when data is invalid", %{conn: conn, playlist: playlist} do
      conn = put conn, Routes.playlist_path(conn, :update, playlist), playlist: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Playlist"
    end
  end

  describe "delete playlist" do
    setup [:create_playlist]

    test "deletes chosen playlist", %{conn: conn, playlist: playlist} do
      conn = delete conn, Routes.playlist_path(conn, :delete, playlist)
      assert redirected_to(conn) == Routes.playlist_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, Routes.playlist_path(conn, :show, playlist)
      end
    end
  end

  defp create_playlist(_) do
    playlist = fixture(:playlist)
    {:ok, playlist: playlist}
  end
end
