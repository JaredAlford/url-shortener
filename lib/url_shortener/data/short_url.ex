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
    |> validate_url(:url)
    |> unique_constraint(:url)
    |> unique_constraint(:slug)
    |> put_change(:slug, get_slug_hash(attrs["url"]))
  end

  defp validate_url(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, url ->
      uri = URI.parse(url)

      host_pieces =
        case uri.host do
          nil -> []
          _something -> uri.host |> String.split(".")
        end

      case (uri.scheme == "http" or uri.scheme == "https") and Enum.count(host_pieces) > 1 and
             not Enum.any?(host_pieces, fn piece -> piece == "" end) do
        true -> []
        false -> [{field, options[:message] || "Invalid URL"}]
      end
    end)
  end

  defp get_slug_hash(url) do
    case url do
      nil -> nil
      default -> :crypto.hash(:sha, default) |> Base.encode32() |> String.slice(0..7)
    end
  end
end
