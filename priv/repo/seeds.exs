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

locations = [
  %{name: "Commercial field"},
  %{name: "Home garden"},
  %{name: "Sentinel plot"},
  %{name: "Research plot"},
  %{name: "Greenhouse"},
  %{name: "Nursery"},
  %{name: "Forest"},
  %{name: "Other"},
]
# PlantAid.Repo.insert_all(LocationType, locations)
for l <- locations, do: PlantAid.ResearchAdmin.create_location_type(l)
