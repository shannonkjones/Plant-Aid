defmodule PlantAid.ResearchAdmin do
  @moduledoc """
  The ResearchAdmin context.
  """

  import Ecto.Query, warn: false
  alias PlantAid.Repo

  alias PlantAid.Accounts.User
  alias PlantAid.ResearchAdmin.LocationType

  @behaviour Bodyguard.Policy

  def authorize(action, user, _params) when action in [:delete_location_type, :delete_county], do: User.is_superuser?(user)
  def authorize(_action, user, _params), do: User.is_superuser_or_research_admin?(user)

  @doc """
  Returns the list of location_types.

  ## Examples

      iex> list_location_types()
      [%LocationType{}, ...]

  """
  def list_location_types do
    Repo.all(LocationType)
  end

  @doc """
  Gets a single location_type.

  Raises `Ecto.NoResultsError` if the Location type does not exist.

  ## Examples

      iex> get_location_type!(123)
      %LocationType{}

      iex> get_location_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_location_type!(id), do: Repo.get!(LocationType, id)

  @doc """
  Creates a location_type.

  ## Examples

      iex> create_location_type(%{field: value})
      {:ok, %LocationType{}}

      iex> create_location_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_location_type(attrs \\ %{}) do
    %LocationType{}
    |> LocationType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a location_type.

  ## Examples

      iex> update_location_type(location_type, %{field: new_value})
      {:ok, %LocationType{}}

      iex> update_location_type(location_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_location_type(%LocationType{} = location_type, attrs) do
    location_type
    |> LocationType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a location_type.

  ## Examples

      iex> delete_location_type(location_type)
      {:ok, %LocationType{}}

      iex> delete_location_type(location_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_location_type(%LocationType{} = location_type) do
    Repo.delete(location_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking location_type changes.

  ## Examples

      iex> change_location_type(location_type)
      %Ecto.Changeset{data: %LocationType{}}

  """
  def change_location_type(%LocationType{} = location_type, attrs \\ %{}) do
    LocationType.changeset(location_type, attrs)
  end

  alias PlantAid.ResearchAdmin.County

  @doc """
  Returns the list of counties.

  ## Examples

      iex> list_counties()
      [%County{}, ...]

  """
  def list_counties do
    Repo.all(County)
  end

  @doc """
  Gets a single county.

  Raises `Ecto.NoResultsError` if the County does not exist.

  ## Examples

      iex> get_county!(123)
      %County{}

      iex> get_county!(456)
      ** (Ecto.NoResultsError)

  """
  def get_county!(id), do: Repo.get!(County, id)

  @doc """
  Creates a county.

  ## Examples

      iex> create_county(%{field: value})
      {:ok, %County{}}

      iex> create_county(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_county(attrs \\ %{}) do
    %County{}
    |> County.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a county.

  ## Examples

      iex> update_county(county, %{field: new_value})
      {:ok, %County{}}

      iex> update_county(county, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_county(%County{} = county, attrs) do
    county
    |> County.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a county.

  ## Examples

      iex> delete_county(county)
      {:ok, %County{}}

      iex> delete_county(county)
      {:error, %Ecto.Changeset{}}

  """
  def delete_county(%County{} = county) do
    Repo.delete(county)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking county changes.

  ## Examples

      iex> change_county(county)
      %Ecto.Changeset{data: %County{}}

  """
  def change_county(%County{} = county, attrs \\ %{}) do
    County.changeset(county, attrs)
  end
end
