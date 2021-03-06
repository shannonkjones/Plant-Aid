defmodule PlantAid.Admin.Host do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [type: :utc_datetime]

  schema "hosts" do
    field :common_name, :string
    field :scientific_name, :string

    has_many :varieties, PlantAid.Admin.HostVariety

    has_many :observations, PlantAid.Observations.Observation

    timestamps()
  end

  @doc false
  def changeset(host, attrs) do
    host
    |> cast(attrs, [:common_name, :scientific_name])
    |> validate_required([:common_name, :scientific_name])
  end

  defimpl Phoenix.HTML.Safe, for: PlantAid.Admin.Host do
    def to_iodata(host) do
      [host.common_name, " (", host.scientific_name, ")"]
    end
  end
end
