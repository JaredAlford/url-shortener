defmodule UrlShortenerWeb.ShortUrlLive.Show do
  use UrlShortenerWeb, :live_view

  alias UrlShortener.Data

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:short_url, Data.get_short_url!(id))}
  end

  defp page_title(:show), do: "Show Short url"
  defp page_title(:edit), do: "Edit Short url"
end
