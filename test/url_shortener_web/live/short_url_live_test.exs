defmodule UrlShortenerWeb.ShortUrlLiveTest do
  use UrlShortenerWeb.ConnCase

  import Phoenix.LiveViewTest

  alias UrlShortener.Data

  @create_attrs %{slug: "some slug", url: "some url"}
  @create_other_attrs %{slug: "some other slug", url: "some other url"}
  @update_attrs %{slug: "some updated slug", url: "some updated url"}
  @invalid_attrs %{slug: nil, url: nil}

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

    test "lists all short_urls", %{conn: conn, short_url: short_url} do
      {:ok, _index_live, html} = live(conn, Routes.short_url_index_path(conn, :index))

      assert html =~ "Listing Short urls"
      assert html =~ short_url.slug
    end

    test "saves new short_url", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.short_url_index_path(conn, :index))

      assert index_live |> element("a", "New Short url") |> render_click() =~
               "New Short url"

      assert_patch(index_live, Routes.short_url_index_path(conn, :new))

      assert index_live
             |> form("#short_url-form", short_url: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#short_url-form", short_url: @create_other_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.short_url_index_path(conn, :index))

      assert html =~ "Short url created successfully"
      assert html =~ "some slug"
    end

    test "updates short_url in listing", %{conn: conn, short_url: short_url} do
      {:ok, index_live, _html} = live(conn, Routes.short_url_index_path(conn, :index))

      assert index_live |> element("#short_url-#{short_url.id} a", "Edit") |> render_click() =~
               "Edit Short url"

      assert_patch(index_live, Routes.short_url_index_path(conn, :edit, short_url))

      assert index_live
             |> form("#short_url-form", short_url: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#short_url-form", short_url: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.short_url_index_path(conn, :index))

      assert html =~ "Short url updated successfully"
      assert html =~ "some updated slug"
    end

    test "deletes short_url in listing", %{conn: conn, short_url: short_url} do
      {:ok, index_live, _html} = live(conn, Routes.short_url_index_path(conn, :index))

      assert index_live |> element("#short_url-#{short_url.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#short_url-#{short_url.id}")
    end
  end

  describe "Show" do
    setup [:create_short_url]

    test "displays short_url", %{conn: conn, short_url: short_url} do
      {:ok, _show_live, html} = live(conn, Routes.short_url_show_path(conn, :show, short_url))

      assert html =~ "Show Short url"
      assert html =~ short_url.slug
    end

    test "updates short_url within modal", %{conn: conn, short_url: short_url} do
      {:ok, show_live, _html} = live(conn, Routes.short_url_show_path(conn, :show, short_url))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Short url"

      assert_patch(show_live, Routes.short_url_show_path(conn, :edit, short_url))

      assert show_live
             |> form("#short_url-form", short_url: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#short_url-form", short_url: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.short_url_show_path(conn, :show, short_url))

      assert html =~ "Short url updated successfully"
      assert html =~ "some updated slug"
    end
  end
end
