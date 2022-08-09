defmodule PlantAid.Observations.ResearchPlotDetails do
  use Ecto.Schema
  import Ecto.Changeset

  alias PlantAid.Observations.Observation

  schema "research_plot_details" do
    field :block, :string
    field :plant_id, :string
    field :treatment, :string

    belongs_to :observation, Observation

    timestamps()
  end

  @doc false
  def changeset(research_plot_details, attrs) do
    research_plot_details
    |> cast(attrs, [:treatment, :block, :plant_id])
    # |> validate_required([:treatment, :block, :plant_id])
  end
end