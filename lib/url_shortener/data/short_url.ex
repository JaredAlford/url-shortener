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
    |> cast(attrs, [:url, :slug])
    |> validate_required([:url, :slug])
    |> unique_constraint(:url)
    |> unique_constraint(:slug)
  end
end
