defmodule PlantAid.Admin.Host do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hosts" do
    field :common_name, :string
    field :scientific_name, :string

    timestamps()
  end

  @doc false
  def changeset(host, attrs) do
    host
    |> cast(attrs, [:common_name, :scientific_name])
    |> validate_required([:common_name, :scientific_name])
  end
end
