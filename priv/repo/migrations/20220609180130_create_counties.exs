defmodule PlantAid.Repo.Migrations.CreateCounties do
  use Ecto.Migration

  def change do
    create table(:counties) do
      add :name, :string
      add :state, :string

      timestamps()
    end

    create unique_index(:counties, [:name, :state])
  end
end
