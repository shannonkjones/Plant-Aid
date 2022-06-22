defmodule PlantAid.Repo.Migrations.CreateCounties do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"

    create table(:counties) do
      add :name, :string
      add :state, :string
    end

    execute "SELECT AddGeometryColumn ('counties','geom',4326,'MULTIPOLYGON',2)"

    execute "CREATE INDEX counties_geom_index ON counties USING GIST (geom)"

    create unique_index(:counties, [:name, :state])
  end
end
