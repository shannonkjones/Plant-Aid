defmodule PlantAid.ResearchAdmin.LocationType do
  use Ecto.Schema
  import Ecto.Changeset

  schema "location_types" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(location_type, attrs) do
    location_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
