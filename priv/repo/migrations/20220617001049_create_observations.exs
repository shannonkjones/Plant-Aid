defmodule PlantAid.Repo.Migrations.CreateObservations do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"

    create table(:observations) do
      add :observation_date, :utc_datetime
      add :organic, :boolean, default: false, null: false
      add :control_method, :string
      add :host_other, :string
      add :notes, :string
      add :user_id, references(:users, on_delete: :nothing)
      # add :county_id, references(:counties, on_delete: :nothing)
      add :location_type_id, references(:location_types, on_delete: :nothing)
      add :suspected_pathology_id, references(:pathologies, on_delete: :nothing)
      add :host_id, references(:hosts, on_delete: :nothing)
      add :host_variety_id, references(:host_varieties, on_delete: :nothing)

      timestamps()
    end

    execute("SELECT AddGeometryColumn ('observations','coordinates',4326,'POINT',2);")
    execute("CREATE INDEX observations_coordinates_index ON observations USING GIST (coordinates);")

    create index(:observations, [:user_id])
    # create index(:observations, [:county_id])
    create index(:observations, [:location_type_id])
    create index(:observations, [:suspected_pathology_id])
    create index(:observations, [:host_id])
    create index(:observations, [:host_variety_id])
  end
end
