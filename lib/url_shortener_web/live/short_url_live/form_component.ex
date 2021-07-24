defmodule UrlShortenerWeb.ShortUrlLive.FormComponent do
  use UrlShortenerWeb, :live_component

  alias UrlShortener.Data

  @impl true
  def update(%{short_url: short_url} = assigns, socket) do
    changeset = Data.change_short_url(short_url)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"short_url" => short_url_params}, socket) do
    changeset =
      socket.assigns.short_url
      |> Data.change_short_url(short_url_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"short_url" => short_url_params}, socket) do
    save_short_url(socket, socket.assigns.action, short_url_params)
  end

  defp save_short_url(socket, :edit, short_url_params) do
    case Data.update_short_url(socket.assigns.short_url, short_url_params) do
      {:ok, _short_url} ->
        {:noreply,
         socket
         |> put_flash(:info, "Short url updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_short_url(socket, :new, short_url_params) do
    case Data.create_short_url(short_url_params) do
      {:ok, _short_url} ->
        {:noreply,
         socket
         |> put_flash(:info, "Short url created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
