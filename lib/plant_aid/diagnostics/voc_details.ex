defmodule PlantAid.Diagnostics.VOCDetails do
  use Ecto.Schema
  import Ecto.Changeset

  alias PlantAid.Observations.Observation

  schema "voc_details" do
    field :disease_presence, :float
    field :result_image_urls, {:array, :string}, default: []
    field :status, Ecto.Enum, values: [:unsubmitted, :submitted], default: :unsubmitted

    belongs_to :observation, Observation

    timestamps()
  end

  @doc false
  def changeset(voc_details, attrs) do
    voc_details
    |> cast(attrs, [:result_image_urls])
    # |> validate_required([:status, :disease_presence, :result_image_urls])
  end
end
