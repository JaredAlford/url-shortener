defmodule UrlShortenerWeb.ShortUrlLiveTest do
  use UrlShortenerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias UrlShortener.Data

  @create_attrs %{url: "http://yahoo.com", slug: "12345678"}

  defp fixture(:short_url) do
    {:ok, short_url} = Data.create_short_url(@create_attrs)
    short_url
  end

  defp create_short_url(_) do
    short_url = fixture(:short_url)
    %{short_url: short_url}
  end

  describe "Index" do
    setup [:create_short_url]

    test "lists all short_urls", %{conn: conn, short_url: _short_url} do
      {:ok, _index_live, html} = live(conn, Routes.short_url_index_path(conn, :index))

      assert html =~ "Shortened URLs"
    end

    test "saves new short_url", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.short_url_index_path(conn, :index))

      assert index_live |> element("a", "New Short URL") |> render_click() =~
               "New Short URL"

      assert_patch(index_live, Routes.short_url_index_path(conn, :new))
    end
  end

  describe "Show" do
    setup [:create_short_url]

    test "displays short_url", %{conn: conn, short_url: short_url} do
      {:ok, _show_live, html} = live(conn, Routes.short_url_show_path(conn, :show, short_url))

      assert html =~ "Shortened URL"
      assert html =~ short_url.url
    end

    test "updates short_url within modal", %{conn: conn, short_url: short_url} do
      {:ok, show_live, _html} = live(conn, Routes.short_url_show_path(conn, :show, short_url))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Short URL"

      assert_patch(show_live, Routes.short_url_show_path(conn, :edit, short_url))
    end
  end
end
