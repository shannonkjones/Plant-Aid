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

alias PlantAid.ResearchAdmin.{
  LocationType,
  County
}

timestamp = DateTime.utc_now() |> DateTime.truncate(:second)

# Location types
location_types =
  [
    "Commercial field",
    "Home garden",
    "Sentinel plot",
    "Research plot",
    "Greenhouse",
    "Nursery",
    "Forest",
    "Other"
  ]
  |> Enum.map(fn name -> %{name: name, inserted_at: timestamp, updated_at: timestamp} end)

PlantAid.Repo.insert_all(LocationType, location_types)

# Counties
# Run support/counties/counties.sh to generate or update the counties.csv file if necessary
counties =
  Path.expand("support/counties/counties.csv")
  |> File.stream!()
  |> NimbleCSV.RFC4180.parse_stream()
  |> Stream.map(fn [county, state] ->
    %{
      name: :binary.copy(county),
      state: :binary.copy(state),
      inserted_at: timestamp,
      updated_at: timestamp
    }
  end)
  |> Enum.to_list()

PlantAid.Repo.insert_all(County, counties)
