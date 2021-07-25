defmodule UrlShortenerWeb.ShortUrlLive.Index do
  use UrlShortenerWeb, :live_view

  alias UrlShortener.Data
  alias UrlShortener.Data.ShortUrl

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :short_urls, list_short_urls())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Short URL")
    |> assign(:short_url, Data.get_short_url!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Short URL")
    |> assign(:short_url, %ShortUrl{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Short URLs")
    |> assign(:short_url, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    short_url = Data.get_short_url!(id)
    {:ok, _} = Data.delete_short_url(short_url)

    {:noreply, assign(socket, :short_urls, list_short_urls())}
  end

  defp list_short_urls do
    Data.list_short_urls()
  end
end
