# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PlantAid.Repo.insert!(%PlantAid.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PlantAid.ResearchAdmin.LocationType

timestamp = DateTime.utc_now() |> DateTime.truncate(:second)

location_types = [
  %{name: "Commercial field", inserted_at: timestamp, updated_at: timestamp},
  %{name: "Home garden", inserted_at: timestamp, updated_at: timestamp},
  %{name: "Sentinel plot", inserted_at: timestamp, updated_at: timestamp},
  %{name: "Research plot", inserted_at: timestamp, updated_at: timestamp},
  %{name: "Greenhouse", inserted_at: timestamp, updated_at: timestamp},
  %{name: "Nursery", inserted_at: timestamp, updated_at: timestamp},
  %{name: "Forest", inserted_at: timestamp, updated_at: timestamp},
  %{name: "Other", inserted_at: timestamp, updated_at: timestamp}
]

PlantAid.Repo.insert_all(LocationType, location_types)
