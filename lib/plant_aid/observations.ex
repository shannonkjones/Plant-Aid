defmodule PlantAid.Observations do
  @moduledoc """
  The Observations context.
  """

  import Ecto.Query, warn: false
  alias PlantAid.Repo

  alias PlantAid.Observations.Observation

  @doc """
  Returns the list of observations.

  ## Examples

      iex> list_observations()
      [%Observation{}, ...]

  """
  def list_observations(filter) do
    IO.inspect(filter, label: "filter")
    base_query()
    |> build_query(filter.changes)
    |> Repo.all()
    |> Repo.preload([:location_type, :host, :host_variety, :suspected_pathology])
  end

  @doc """
  Gets a single observation.

  Raises `Ecto.NoResultsError` if the Observation does not exist.

  ## Examples

      iex> get_observation!(123)
      %Observation{}

      iex> get_observation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_observation!(id) do
    observation = Repo.get!(Observation, id) |> Repo.preload([:location_type, :host, :host_variety, :suspected_pathology])
    {longitude, latitude} = observation.coordinates.coordinates
    observation
    |> Map.put(:latitude, latitude)
    |> Map.put(:longitude, longitude)
  end

  @doc """
  Creates a observation.

  ## Examples

      iex> create_observation(%{field: value})
      {:ok, %Observation{}}

      iex> create_observation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_observation(user, attrs \\ %{}) do
    %Observation{}
    |> Observation.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a observation.

  ## Examples

      iex> update_observation(observation, %{field: new_value})
      {:ok, %Observation{}}

      iex> update_observation(observation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_observation(%Observation{} = observation, attrs) do
    observation
    |> Observation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a observation.

  ## Examples

      iex> delete_observation(observation)
      {:ok, %Observation{}}

      iex> delete_observation(observation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_observation(%Observation{} = observation) do
    Repo.delete(observation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking observation changes.

  ## Examples

      iex> change_observation(observation)
      %Ecto.Changeset{data: %Observation{}}

  """
  def change_observation(%Observation{} = observation, attrs \\ %{}) do
    observation
    # |> Repo.preload([:user, :location_type])
    |> Observation.changeset(attrs)
  end

  defp base_query do
    from o in Observation
  end

  defp build_query(query, criteria) do
    Enum.reduce(criteria, query, &compose_query/2)
  end

  # defp compose_query({"user_id", user_id}, query) do
  #   where(query, [o], o.user_id == ^user_id)
  # end

  # defp compose_query({"tags", tags}, query) do
  #   query
  #   |> join(:left, [p], t in assoc(p, :tags))
  #   |> where([_p, t], t.name in ^tags)
  # end

  defp compose_query({key, value}, query) when key in [:user_id, :location_type_id, :host_id, :host_variety_id, :suspected_pathology_id] do
    where(query, [o], ^[{key, value}])
  end

  defp compose_query(_unsupported_param, query) do
    query
  end
end
