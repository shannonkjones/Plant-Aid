defmodule PlantAid.Repo.Migrations.CreatePathologies do
  use Ecto.Migration

  def change do
    create table(:pathologies) do
      add :common_name, :string
      add :scientific_name, :string

      timestamps()
    end

    create unique_index(:pathologies, [:common_name])
  end
end
