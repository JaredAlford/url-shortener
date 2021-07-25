defmodule UrlShortenerWeb.RedirectControllerTest do
  use UrlShortenerWeb.ConnCase

  alias UrlShortener.Data

  describe "show" do
    test "redirects", %{conn: conn} do
      {:ok, short_url} = Data.create_short_url(%{url: "https://google.com"})
      conn = get(conn, Routes.redirect_path(conn, :show, short_url.slug))
      assert "https://google.com" = redirected_to(conn, 302)
    end
  end
end
