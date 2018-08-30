defmodule LohiUi.AdminTest do
  use LohiUi.DataCase

  alias LohiUi.Admin

  describe "playlists" do
    alias LohiUi.Admin.Playlist

    @valid_attrs %{tag: "some tag"}
    @update_attrs %{tag: "some updated tag"}
    @invalid_attrs %{tag: nil}

    def playlist_fixture(attrs \\ %{}) do
      {:ok, playlist} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Admin.create_playlist()

      playlist
    end

    test "list_playlists/0 returns all playlists" do
      playlist = playlist_fixture()
      assert Admin.list_playlists() == [playlist]
    end

    test "get_playlist!/1 returns the playlist with given id" do
      playlist = playlist_fixture()
      assert Admin.get_playlist!(playlist.id) == playlist
    end

    test "create_playlist/1 with valid data creates a playlist" do
      assert {:ok, %Playlist{} = playlist} = Admin.create_playlist(@valid_attrs)
      assert playlist.tag == "some tag"
    end

    test "create_playlist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_playlist(@invalid_attrs)
    end

    test "update_playlist/2 with valid data updates the playlist" do
      playlist = playlist_fixture()
      assert {:ok, %Playlist{} = playlist} = Admin.update_playlist(playlist, @update_attrs)
      
      assert playlist.tag == "some updated tag"
    end

    test "update_playlist/2 with invalid data returns error changeset" do
      playlist = playlist_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_playlist(playlist, @invalid_attrs)
      assert playlist == Admin.get_playlist!(playlist.id)
    end

    test "delete_playlist/1 deletes the playlist" do
      playlist = playlist_fixture()
      assert {:ok, %Playlist{}} = Admin.delete_playlist(playlist)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_playlist!(playlist.id) end
    end

    test "change_playlist/1 returns a playlist changeset" do
      playlist = playlist_fixture()
      assert %Ecto.Changeset{} = Admin.change_playlist(playlist)
    end
  end
end
