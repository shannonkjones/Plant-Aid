defmodule PlantAid.Repo.Migrations.CreateHosts do
  use Ecto.Migration

  def change do
    create table(:hosts) do
      add :common_name, :string
      add :scientific_name, :string

      timestamps()
    end

    create unique_index(:hosts, [:common_name])
  end
end
