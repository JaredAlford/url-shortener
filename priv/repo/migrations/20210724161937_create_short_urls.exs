defmodule UrlShortener.Repo.Migrations.CreateShortUrls do
  use Ecto.Migration

  def change do
    create table(:short_urls) do
      add :url, :string
      add :slug, :string

      timestamps()
    end

    create unique_index(:short_urls, [:url])
    create unique_index(:short_urls, [:slug])
  end
end
