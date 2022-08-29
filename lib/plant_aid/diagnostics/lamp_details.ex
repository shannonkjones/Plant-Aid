defmodule PlantAid.Diagnostics.LAMPDetails do
  use Ecto.Schema
  import Ecto.Changeset

  alias PlantAid.Observations.Observation

  @derive {Jason.Encoder, only: [:interpretted_results, :status]}
  schema "lamp_details" do
    field :final_image_urls, {:array, :string}, default: []
    field :initial_image_urls, {:array, :string}, default: []
    field :interpretted_results, :map
    field :status, Ecto.Enum, values: [:unsubmitted, :submitted], default: :unsubmitted

    belongs_to :observation, Observation

    timestamps()
  end

  @doc false
  def changeset(lamp_details, attrs) do
    lamp_details
    |> cast(attrs, [:initial_image_urls, :final_image_urls])
    # |> validate_required([:initial_image_urls, :final_image_urls])
    # |> validate_length(:initial_image_urls, min: 1)
    # |> validate_length(:final_image_urls, min: 1)
  end
end
