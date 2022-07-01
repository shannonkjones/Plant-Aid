defmodule PlantAid.Observations.Observation do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [type: :utc_datetime]

  alias PlantAid.Admin.{
    Host,
    HostVariety,
    LocationType,
    Pathology
  }

  schema "observations" do
    field :control_method, :string
    field :coordinates, Geo.PostGIS.Geometry
    field :latitude, :float, virtual: true
    field :longitude, :float, virtual: true
    field :host_other, :string
    field :notes, :string
    field :observation_date, :utc_datetime
    field :organic, :boolean, default: false

    belongs_to :user, PlantAid.Accounts.User
    belongs_to :host, Host
    belongs_to :host_variety, HostVariety
    belongs_to :location_type, LocationType
    belongs_to :suspected_pathology, Pathology

    timestamps()
  end

  @doc false
  def changeset(observation, attrs) do
    observation
    |> cast(attrs, [:observation_date, :organic, :control_method, :host_other, :notes, :location_type_id, :suspected_pathology_id, :host_id, :host_variety_id])
    |> assoc_constraint(:location_type)
    |> assoc_constraint(:suspected_pathology)
    |> assoc_constraint(:host)
    |> assoc_constraint(:host_variety)
    # |> validate_required([:observation_date, :coordinates, :location_type])
    |> cast(attrs, [:latitude, :longitude])
    |> validate_number(:latitude, greater_than_or_equal_to: -90, less_than_or_equal_to: 90)
    |> validate_number(:longitude, greater_than_or_equal_to: -180, less_than_or_equal_to: 180)
    |> maybe_convert_lat_long_to_point()
  end

  def maybe_convert_lat_long_to_point(changeset) do
    cond do
      get_change(changeset, :latitude) || get_change(changeset, :longitude) ->
        latitude = fetch_field!(changeset, :latitude)
        longitude = fetch_field!(changeset, :longitude)
        coordinates = %Geo.Point{coordinates: {longitude, latitude}, srid: 4326}

        changeset
        |> put_change(:coordinates, coordinates)
      true ->
        changeset
    end
  end

  defimpl Phoenix.HTML.Safe, for: Geo.Point do
    def to_iodata(point) do
      {longitude, latitude} = point.coordinates
      [Float.to_string(latitude), ", ", Float.to_string(longitude)]
    end
  end
end
