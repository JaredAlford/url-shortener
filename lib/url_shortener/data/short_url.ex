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
    |> validate_length(:url, min: 10, max: 2000)
    |> unique_constraint(:url)
    |> unique_constraint(:slug)
    |> put_change(:slug, get_slug_hash(attrs["url"]))
  end

  defp get_slug_hash(url) do
    case url do
      nil -> nil
      default -> :crypto.hash(:sha, default) |> Base.encode32() |> String.slice(0..7)
    end
  end
end
