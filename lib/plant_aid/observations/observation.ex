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
    |> cast(attrs, [:observation_date, :coordinates, :organic, :control_method, :host_other, :notes, :location_type_id, :suspected_pathology_id, :host_id])
    # |> cast_assoc(:location_type)
    |> assoc_constraint(:location_type)
    |> assoc_constraint(:suspected_pathology)
    |> assoc_constraint(:host)
    # |> validate_required([:observation_date, :coordinates, :location_type])
  end

  defimpl Phoenix.HTML.Safe, for: Geo.Point do
    def to_iodata(point) do
      {longitude, latitude} = point.coordinates
      [Float.to_string(latitude), ", ", Float.to_string(longitude)]
    end
  end
end
