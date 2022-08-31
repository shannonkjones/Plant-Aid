defmodule PlantAid.Observations do
  @moduledoc """
  The Observations context.
  """

  use Filterable
  import Ecto.Query, warn: false
  import Geo.PostGIS
  alias PlantAid.Repo

  alias PlantAid.Observations.{
    Filter,
    Observation
  }

  # alias PlantAid.Tests.LAMPDetails
  alias PlantAid.Admin.County

  defmodule Filters do
    use Filterable.DSL
    use Filterable.Ecto.Helpers

    # paginateable(per_page: 20)
    orderable([:observation_date])

    filter user_id(query, value) do
      from o in query, where: o.user_id == ^value
    end

    filter user_ids(query, values) do
      from o in query, where: o.user_id in ^values
    end

    filter host_id(query, value) do
      from o in query, where: o.host_id == ^value
    end

    filter host_ids(query, values) do
      from o in query, where: o.host_id in ^values
    end

    filter host_variety_id(query, value) do
      from o in query, where: o.host_variety_id == ^value
    end

    filter host_variety_ids(query, values) do
      from o in query, where: o.host_variety_id in ^values
    end

    filter location_type_id(query, value) do
      from o in query, where: o.location_type_id == ^value
    end

    filter location_type_ids(query, values) do
      from o in query, where: o.location_type_id in ^values
    end

    filter suspected_pathology_id(query, value) do
      from o in query, where: o.suspected_pathology_id == ^value
    end

    filter suspected_pathology_ids(query, values) do
      from o in query, where: o.suspected_pathology_id in ^values
    end

    filter organic(query, value) do
      from o in query, where: o.organic == ^value
    end

    filter start_date(query, value) do
      from o in query, where: o.observation_date >= ^value
    end

    filter end_date(query, value) do
      from o in query, where: o.observation_date <= ^value
    end

    # filter county_id(query, value) do
    #   from o in query, where: o.county_id == ^value
    # end

    # filter county_ids(query, values) do
    #   from o in query, where: o.county_id in ^values
    # end

    # filter county(query, value) do
    #   from o in query, join: c in County, on: c.name == ^value, where: o.county_id == c.id
    # end

    # filter counties(query, values) do
    #   from o in query, join: c in County, on: c.name in ^values, where: o.county_id == c.id
    # end

    # filter state(query, value) do
    #   from o in query, join: c in County, on: c.state == ^value, where: o.county_id == c.id
    # end

    # filter states(query, values) do
    #   from o in query, join: c in County, on: c.state in ^values, where: o.county_id == c.id
    # end

    filter county_id(query, value) do
      county_query = from c in County, select: [c.geom], where: c.id == ^value
      from o in query, where: st_within(o.coordinates, subquery(county_query))
    end

    filter county_ids(query, values) do
      counties_query = from c in County, select: st_union(c.geom), where: c.id in ^values
      from o in query, where: st_within(o.coordinates, subquery(counties_query))
    end

    filter county(query, {name, state}) do
      counties_query =
        from c in County, select: [c.geom], where: c.name == ^name and c.state == ^state

      from o in query, where: st_within(o.coordinates, subquery(counties_query))
    end

    filter counties(query, values) do
      counties_query = from c in County, select: st_union(c.geom), where: c.name in ^values
      from o in query, where: st_within(o.coordinates, subquery(counties_query))
    end

    filter state(query, value) do
      counties_query = from c in County, select: st_union(c.geom), where: c.state == ^value
      from o in query, where: st_within(o.coordinates, subquery(counties_query))
    end

    filter states(query, values) do
      counties_query = from c in County, select: st_union(c.geom), where: c.state in ^values
      from o in query, where: st_within(o.coordinates, subquery(counties_query))
    end

    filter geometry(query, value) do
      from o in query, where: st_within(o.coordinates, ^value)
    end

    filter geometries(query, values) do
      from o in query, where: st_within(o.coordinates, st_union(^values))
    end
  end

  filterable(Filters, share: false)

  @doc """
  Returns the list of observations.

  ## Examples

      iex> list_observations()
      [%Observation{}, ...]

  """
  def list_observations(filter) do
    {:ok, query, _filter_values} = apply_filters(Observation, filter)

    from(o in query,
      left_join: c in County,
      on: st_contains(c.geom, o.coordinates),
      select: {o, c}
    )
    |> Repo.all()
    |> Enum.map(fn {observation, county} ->
      Map.put(observation, :county, county)
    end)
    |> Repo.preload([
      :location_type,
      :host,
      :host_variety,
      :suspected_pathology,
      :research_plot_details,
      :lamp_details,
      :voc_details
    ])
  end

  def get_county_aggregates() do
    from(c in County,
      inner_join: o in Observation,
      on: st_contains(c.geom, o.coordinates),
      select: {c, count(o.id)},
      group_by: [c.id]
    )
    |> Repo.all()
    |> Enum.map(fn {county, count} ->
      Map.put(county, :observation_count, count)
    end)
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
    {observation, county} =
      from(o in Observation,
        where: o.id == ^id,
        left_join: c in County,
        on: st_contains(c.geom, o.coordinates),
        select: {o, c}
      )
      |> Repo.one!()

    observation =
      if observation.coordinates do
        {longitude, latitude} = observation.coordinates.coordinates

        observation
        |> Map.put(:latitude, latitude)
        |> Map.put(:longitude, longitude)
      else
        observation
      end

    observation
    |> Map.put(:county, county)
    |> Repo.preload([
      :location_type,
      :host,
      :host_variety,
      :suspected_pathology,
      :research_plot_details,
      :lamp_details,
      :voc_details
    ])
  end

  @doc """
  Creates a observation.

  ## Examples

      iex> create_observation(%{field: value})
      {:ok, %Observation{}}

      iex> create_observation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_observation(%Observation{} = observation, attrs \\ %{}, after_save \\ &{:ok, &1}) do
    observation
    |> Observation.changeset(attrs)
    |> Repo.insert()
    |> after_save(after_save)
  end

  @doc """
  Updates a observation.

  ## Examples

      iex> update_observation(observation, %{field: new_value})
      {:ok, %Observation{}}

      iex> update_observation(observation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_observation(%Observation{} = observation, attrs, after_save \\ &{:ok, &1}) do
    observation
    |> Observation.changeset(attrs)
    |> Repo.update()
    |> after_save(after_save)
  end

  defp after_save({:ok, observation}, func) do
    {:ok, _observation} = func.(observation)
  end

  defp after_save(error, _func), do: error

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
    |> Observation.changeset(attrs)
  end

  # def change_submission(_, attrs \\ %{})

  # def change_submission(%Observation{} = observation, attrs) do
  #   observation
  #   |> Submission.changeset(attrs)
  # end

  # def change_submission(%Submission{} = submission, attrs) do
  #   submission
  #   |> Submission.changeset(attrs)
  # end

  def update_filter(%Filter{} = filter, attrs) do
    filter
    |> Filter.changeset(attrs)
    # Supposedly this value doesn't matter, but most examples use :update
    |> Ecto.Changeset.apply_action!(:update)
  end

  def change_filter(%Filter{} = filter, attrs \\ %{}) do
    filter
    |> Filter.changeset(attrs)
  end
end
