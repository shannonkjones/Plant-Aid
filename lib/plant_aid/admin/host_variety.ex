defmodule PlantAid.Admin.HostVariety do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [type: :utc_datetime]

  schema "host_varieties" do
    field :name, :string

    belongs_to :host, PlantAid.Admin.Host

    timestamps()
  end

  @doc false
  def changeset(host_variety, attrs) do
    host_variety
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
