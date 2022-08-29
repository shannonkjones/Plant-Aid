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

  alias PlantAid.Diagnostics.{LAMPDetails, VOCDetails}
  alias PlantAid.Observations.ResearchPlotDetails

  @derive {Jason.Encoder,
           only: [
             :coordinates,
             :observation_date,
             :status,
             :host,
             :host_variety,
             :location_type,
             :suspected_pathology,
             :research_plot_details,
             :lamp_details,
             :voc_details
           ]}
  schema "observations" do
    field :control_method, :string
    field :coordinates, Geo.PostGIS.Geometry
    field :latitude, :float, virtual: true
    field :longitude, :float, virtual: true
    field :host_other, :string
    field :notes, :string
    field :observation_date, :utc_datetime
    field :organic, :boolean, default: false
    field :image_urls, {:array, :string}, default: []
    field :status, Ecto.Enum, values: [:unsubmitted, :submitted], default: :unsubmitted

    belongs_to :user, PlantAid.Accounts.User
    belongs_to :host, Host
    belongs_to :host_variety, HostVariety
    belongs_to :location_type, LocationType
    belongs_to :suspected_pathology, Pathology

    has_one :research_plot_details, ResearchPlotDetails
    has_one :lamp_details, LAMPDetails
    has_one :voc_details, VOCDetails

    timestamps()
  end

  @doc false
  def changeset(observation, attrs) do
    observation
    |> cast(attrs, [
      :observation_date,
      :organic,
      :control_method,
      :host_other,
      :image_urls,
      :latitude,
      :longitude,
      :notes,
      :location_type_id,
      :suspected_pathology_id,
      :host_id,
      :host_variety_id
    ])
    |> cast_assoc(:research_plot_details)
    |> cast_assoc(:lamp_details)
    |> cast_assoc(:voc_details)
    |> assoc_constraint(:location_type)
    |> assoc_constraint(:suspected_pathology)
    |> assoc_constraint(:host)
    |> assoc_constraint(:host_variety)
    # |> validate_required([:latitude, :longitude, :observation_date])
    |> validate_number(:latitude, greater_than_or_equal_to: -90, less_than_or_equal_to: 90)
    |> validate_number(:longitude, greater_than_or_equal_to: -180, less_than_or_equal_to: 180)
    |> maybe_put_coordinates()
    |> clear_host_variety_id_or_host_other()
  end

  def clear_host_variety_id_or_host_other(changeset) do
    if get_field(changeset, :host) && get_field(changeset, :host).common_name == "Other" do
      changeset
      |> put_change(:host_variety_id, nil)
    else
      changeset
      |> put_change(:host_other, nil)
    end
  end

  def maybe_put_coordinates(changeset) do
    latitude = get_field(changeset, :latitude)
    longitude = get_field(changeset, :longitude)

    if latitude && longitude do
      changeset
      |> put_change(:coordinates, %Geo.Point{coordinates: {longitude, latitude}, srid: 4326})
    else
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
