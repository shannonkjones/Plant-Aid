defmodule PlantAid.Repo.Migrations.CreateLocationTypes do
  use Ecto.Migration

  def change do
    create table(:location_types) do
      add :name, :string

      timestamps()
    end
  end
end
