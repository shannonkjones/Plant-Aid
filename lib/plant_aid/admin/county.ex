defmodule PlantAid.Admin.County do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [type: :utc_datetime]

  schema "counties" do
    field :name, :string
    field :state, :string

    timestamps()
  end

  @doc false
  def changeset(county, attrs) do
    county
    |> cast(attrs, [:name, :state])
    |> validate_required([:name, :state])
  end
end
