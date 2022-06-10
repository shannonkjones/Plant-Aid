defmodule PlantAid.Admin do
  @moduledoc """
  The Admin context.
  """

  import Ecto.Query, warn: false
  alias PlantAid.Repo

  alias PlantAid.Accounts.User
  alias PlantAid.Admin.LocationType

  @behaviour Bodyguard.Policy

  def authorize(action, user, _params)
      when action in [:delete_location_type, :delete_county, :delete_pathology],
      do: User.is_superuser?(user)

  def authorize(_action, user, _params), do: User.is_superuser_or_admin?(user)

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

  alias PlantAid.Admin.County

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

  alias PlantAid.Admin.Pathology

  @doc """
  Returns the list of pathologies.

  ## Examples

      iex> list_pathologies()
      [%Pathology{}, ...]

  """
  def list_pathologies do
    Repo.all(Pathology)
  end

  @doc """
  Gets a single pathology.

  Raises `Ecto.NoResultsError` if the Pathology does not exist.

  ## Examples

      iex> get_pathology!(123)
      %Pathology{}

      iex> get_pathology!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pathology!(id), do: Repo.get!(Pathology, id)

  @doc """
  Creates a pathology.

  ## Examples

      iex> create_pathology(%{field: value})
      {:ok, %Pathology{}}

      iex> create_pathology(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pathology(attrs \\ %{}) do
    %Pathology{}
    |> Pathology.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pathology.

  ## Examples

      iex> update_pathology(pathology, %{field: new_value})
      {:ok, %Pathology{}}

      iex> update_pathology(pathology, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pathology(%Pathology{} = pathology, attrs) do
    pathology
    |> Pathology.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pathology.

  ## Examples

      iex> delete_pathology(pathology)
      {:ok, %Pathology{}}

      iex> delete_pathology(pathology)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pathology(%Pathology{} = pathology) do
    Repo.delete(pathology)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pathology changes.

  ## Examples

      iex> change_pathology(pathology)
      %Ecto.Changeset{data: %Pathology{}}

  """
  def change_pathology(%Pathology{} = pathology, attrs \\ %{}) do
    Pathology.changeset(pathology, attrs)
  end
end
