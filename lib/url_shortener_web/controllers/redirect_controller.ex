defmodule UrlShortenerWeb.RedirectController do
  use UrlShortenerWeb, :controller

  def show(conn, %{"slug" => slug}) do
    case UrlShortener.Data.find_url(slug) do
      nil -> redirect(conn, to: Routes.short_url_index_path(conn, :new))
      url -> redirect(conn, external: url)
    end
  end
end
