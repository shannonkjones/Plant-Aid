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
    |> cast(attrs, [:observation_date, :coordinates, :organic, :control_method, :host_other, :notes])
    |> validate_required([:observation_date, :coordinates])
  end
end
