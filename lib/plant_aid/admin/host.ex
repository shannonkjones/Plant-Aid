defmodule PlantAid.Admin.Host do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [type: :utc_datetime]

  schema "hosts" do
    field :common_name, :string
    field :scientific_name, :string

    has_many :varieties, PlantAid.Admin.HostVariety

    timestamps()
  end

  @doc false
  def changeset(host, attrs) do
    host
    |> cast(attrs, [:common_name, :scientific_name])
    |> validate_required([:common_name, :scientific_name])
  end
end
