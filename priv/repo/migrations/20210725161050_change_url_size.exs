defmodule UrlShortener.Repo.Migrations.ChangeUrlSize do
  use Ecto.Migration

  def change do
    alter table(:short_urls) do
      modify :url, :string, size: 2000
      modify :slug, :string, size: 8
    end
  end
end
