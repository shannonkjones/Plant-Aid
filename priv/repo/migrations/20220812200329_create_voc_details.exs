defmodule PlantAid.Repo.Migrations.CreateVocDetails do
  use Ecto.Migration

  def change do
    create table(:voc_details) do
      add :status, :string
      add :disease_presence, :float
      add :result_image_urls, {:array, :string}
      add :observation_id, references(:observations, on_delete: :nothing)

      timestamps()
    end

    create index(:voc_details, [:observation_id])
  end
end
