defmodule UrlShortener.Data.ShortUrl do
  use Ecto.Schema
  import Ecto.Changeset

  schema "short_urls" do
    field :slug, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(short_url, attrs) do
    short_url
    |> cast(attrs, [:url])
    |> validate_required([:url])
    |> validate_length(:url, max: 2000)
    |> validate_url()
    |> unique_constraint(:url)
    |> unique_constraint(:slug)
    |> put_change(:slug, get_slug_hash(attrs["url"]))
  end

  def get_shortened_url(short_url = %UrlShortener.Data.ShortUrl{}) do
    "#{UrlShortenerWeb.Endpoint.url()}/#{short_url.slug}"
  end

  defp validate_url(changeset) do
    uri = URI.parse(get_field(changeset, :url) || "")

    host_pieces =
      case uri.host do
        nil -> []
        _something -> uri.host |> String.split(".")
      end

    case (uri.scheme == "http" or uri.scheme == "https") and Enum.count(host_pieces) > 1 and
           not Enum.any?(host_pieces, fn piece -> piece == "" end) do
      true -> changeset
      false -> add_error(changeset, :url, "URL is not valid")
    end
  end

  defp get_slug_hash(url) do
    case url do
      nil -> nil
      default -> :crypto.hash(:sha, default) |> Base.encode32() |> String.slice(0..7)
    end
  end
end
