defmodule UrlShortener.DataTest do
  use UrlShortener.DataCase

  alias UrlShortener.Data

  describe "short_urls" do
    alias UrlShortener.Data.ShortUrl

    @valid_attrs %{url: "https://www.google.com", slug: "12345678"}
    @update_attrs %{url: "https://facebook.com", slug: "ABDCEFGH"}
    @invalid_attrs %{url: nil, slug: nil}

    def short_url_fixture(attrs \\ %{}) do
      {:ok, short_url} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_short_url()

      short_url
    end

    test "list_short_urls/0 returns all short_urls" do
      short_url = short_url_fixture()
      assert Data.list_short_urls() == [short_url]
    end

    test "get_short_url!/1 returns the short_url with given id" do
      short_url = short_url_fixture()
      assert Data.get_short_url!(short_url.id) == short_url
    end

    test "create_short_url/1 with valid data creates a short_url" do
      assert {:ok, %ShortUrl{} = short_url} = Data.create_short_url(@valid_attrs)
      assert short_url.url == "https://www.google.com"
    end

    test "create_short_url/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_short_url(@invalid_attrs)
    end

    test "update_short_url/2 with valid data updates the short_url" do
      short_url = short_url_fixture()
      assert {:ok, %ShortUrl{} = short_url} = Data.update_short_url(short_url, @update_attrs)
      assert short_url.url == "https://facebook.com"
    end

    test "update_short_url/2 with invalid data returns error changeset" do
      short_url = short_url_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_short_url(short_url, @invalid_attrs)
      assert short_url == Data.get_short_url!(short_url.id)
    end

    test "delete_short_url/1 deletes the short_url" do
      short_url = short_url_fixture()
      assert {:ok, %ShortUrl{}} = Data.delete_short_url(short_url)
      assert_raise Ecto.NoResultsError, fn -> Data.get_short_url!(short_url.id) end
    end

    test "change_short_url/1 returns a short_url changeset" do
      short_url = short_url_fixture()
      assert %Ecto.Changeset{} = Data.change_short_url(short_url)
    end
  end
end
