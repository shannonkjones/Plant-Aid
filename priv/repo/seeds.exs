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

alias PlantAid.Admin.{
  County,
  Host,
  HostVariety,
  LocationType,
  Pathology
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

# Pathologies
pathologies = [
  {"Sudden Oak Death", "Phytophthora ramorum"},
  {"Late Blight", "Phytophthora infestans"},
  {"Tomato spotted wilt virus", nil}
]
|> Enum.map(fn {common_name, scientific_name} -> %{common_name: common_name, scientific_name: scientific_name, inserted_at: timestamp, updated_at: timestamp} end)

PlantAid.Repo.insert_all(Pathology, pathologies)

# Hosts
hosts = [
  {"Tanoak", "Notholithocarpus densiflorus"},
  {"Bay Laurel", "Umbellularia californica"},
  {"Tomato", "Solanum lycopersicum"},
  {"Potato", "Solanum tuberosum"},
  {"Rhododendron", "Ericaceae"}
]
|> Enum.map(fn {common_name, scientific_name} -> %{common_name: common_name, scientific_name: scientific_name, inserted_at: timestamp, updated_at: timestamp} end)

PlantAid.Repo.insert_all(Host, hosts)

# Host varieties
# TODO: don't love the hard coding of IDs
host_varieties = [
  # Tomato
  {3, "German Johnson"},
  {3, "Mortgage Lifter"},
  {3, "Celebrity"},
  {3, "Amy's Sugar Gem"},
  # Potato
  {4, "Butte"},
  {4, "Onaway"},
  {4, "Elba"},
  {4, "Yukon Gold"},
  {4, "All-Blue"},
  {4, "Russian Banana"},
  # Rhododendron
  {5, "Elviira"},
  {5, "Windsong"},
  {5, "White Angel"},
  {5, "Black Satin"},
  {5, "Blue Peter"}
]
|> Enum.map(fn {host_id, name} -> %{host_id: host_id, name: name, inserted_at: timestamp, updated_at: timestamp} end)

PlantAid.Repo.insert_all(HostVariety, host_varieties)

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
