defmodule UrlShortenerWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `UrlShortenerWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, UrlShortenerWeb.ShortUrlLive.FormComponent,
        id: @short_url.id || :new,
        action: @live_action,
        short_url: @short_url,
        return_to: Routes.short_url_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, UrlShortenerWeb.ModalComponent, modal_opts)
  end
end
