defmodule PlantAid.Admin.LocationType do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [type: :utc_datetime]

  schema "location_types" do
    field :name, :string

    has_many :observations, PlantAid.Observations.Observation

    timestamps()
  end

  @doc false
  def changeset(location_type, attrs) do
    location_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
