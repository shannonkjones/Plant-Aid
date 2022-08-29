defmodule PlantAid.Admin.Pathology do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [type: :utc_datetime]

  @derive {Jason.Encoder, only: [:common_name, :scientific_name]}
  schema "pathologies" do
    field :common_name, :string
    field :scientific_name, :string

    timestamps()
  end

  @doc false
  def changeset(pathology, attrs) do
    pathology
    |> cast(attrs, [:common_name, :scientific_name])
    |> validate_required([:common_name, :scientific_name])
  end

  defimpl Phoenix.HTML.Safe, for: PlantAid.Admin.Pathology do
    def to_iodata(pathology) do
      if pathology.scientific_name do
        [pathology.common_name, " (", pathology.scientific_name, ")"]
      else
        [pathology.common_name]
      end
    end
  end
end
