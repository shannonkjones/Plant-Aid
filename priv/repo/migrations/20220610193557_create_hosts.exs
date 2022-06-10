defmodule PlantAid.Repo.Migrations.CreateHosts do
  use Ecto.Migration

  def change do
    create table(:hosts) do
      add :common_name, :string
      add :scientific_name, :string

      timestamps()
    end
  end
end
