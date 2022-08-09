defmodule PlantAid.Repo.Migrations.CreateResearchPlotDetails do
  use Ecto.Migration

  def change do
    create table(:research_plot_details) do
      add :treatment, :string
      add :block, :string
      add :plant_id, :string
      add :observation_id, references(:observations, on_delete: :nothing)

      timestamps()
    end

    create index(:research_plot_details, [:observation_id])
  end
end
