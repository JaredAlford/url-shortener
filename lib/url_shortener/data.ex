defmodule UrlShortener.Data do
  @moduledoc """
  The Data context.
  """

  import Ecto.Query, warn: false
  alias UrlShortener.Repo

  alias UrlShortener.Data.ShortUrl

  @doc """
  Returns the list of short_urls.

  ## Examples

      iex> list_short_urls()
      [%ShortUrl{}, ...]

  """
  def list_short_urls do
    Repo.all(ShortUrl)
  end

  @doc """
  Gets a single short_url.

  Raises `Ecto.NoResultsError` if the Short url does not exist.

  ## Examples

      iex> get_short_url!(123)
      %ShortUrl{}

      iex> get_short_url!(456)
      ** (Ecto.NoResultsError)

  """
  def get_short_url!(id), do: Repo.get!(ShortUrl, id)

  @doc """
  Creates a short_url.

  ## Examples

      iex> create_short_url(%{field: value})
      {:ok, %ShortUrl{}}

      iex> create_short_url(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_short_url(attrs \\ %{}) do
    %ShortUrl{}
    |> ShortUrl.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a short_url.

  ## Examples

      iex> update_short_url(short_url, %{field: new_value})
      {:ok, %ShortUrl{}}

      iex> update_short_url(short_url, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_short_url(%ShortUrl{} = short_url, attrs) do
    short_url
    |> ShortUrl.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a short_url.

  ## Examples

      iex> delete_short_url(short_url)
      {:ok, %ShortUrl{}}

      iex> delete_short_url(short_url)
      {:error, %Ecto.Changeset{}}

  """
  def delete_short_url(%ShortUrl{} = short_url) do
    Repo.delete(short_url)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking short_url changes.

  ## Examples

      iex> change_short_url(short_url)
      %Ecto.Changeset{data: %ShortUrl{}}

  """
  def change_short_url(%ShortUrl{} = short_url, attrs \\ %{}) do
    ShortUrl.changeset(short_url, attrs)
  end

  def find_url(slug) when is_binary(slug) do
    case Repo.get_by(ShortUrl, slug: slug) do
      nil -> nil
      result -> result.url
    end
  end
end
