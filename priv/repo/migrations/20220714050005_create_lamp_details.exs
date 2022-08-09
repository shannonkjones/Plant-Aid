defmodule PlantAid.Repo.Migrations.CreateLampDetails do
  use Ecto.Migration

  def change do
    create table(:lamp_details) do
      add :status, :string
      add :initial_image_urls, {:array, :string}, default: []
      add :final_image_urls, {:array, :string}, default: []
      add :interpretted_results, :map
      add :observation_id, references(:observations, on_delete: :nothing)

      timestamps()
    end

    create index(:lamp_details, [:observation_id])
  end
end
