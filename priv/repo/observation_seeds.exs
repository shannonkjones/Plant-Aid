alias PlantAid.Accounts.User
alias PlantAid.Admin
alias PlantAid.Observations.Observation
alias PlantAid.Repo

timestamp = DateTime.utc_now() |> DateTime.truncate(:second)
users = Repo.all(User)
location_types = Admin.list_location_types()
hosts = Admin.list_hosts()
pathologies = Admin.list_pathologies()

hosts_to_pathologies = %{
    "Tanoak" => ["Sudden Oak Death"],
    "Bay Laurel" => ["Sudden Oak Death"],
    "Tomato" => ["Late Blight", "Tomato Spotted Wilt Virus"],
    "Potato" => ["Late Blight"],
    "Rhododendron" => ["Sudden Oak Death"],
}

min_observations = 2
max_observations = 10

observations = for u <- users do
  num_observations = Enum.random(min_observations..max_observations)
  for _ <- 1..num_observations do
    location_type = Enum.random(location_types)
    host = Enum.random(hosts)
    host_variety = Enum.random(host.varieties)
    suspected_pathology_name = Map.get(hosts_to_pathologies, host.common_name) |> Enum.random()
    suspected_pathology = Enum.find(pathologies, fn p -> p.common_name == suspected_pathology_name end)
    longitude = :rand.uniform() * 4 - 80.947
    latitude = :rand.uniform() * 2 + 34.914

    %{
      observation_date: timestamp,
      coordinates: %Geo.Point{coordinates: {longitude, latitude}, srid: 4326},
      user_id: u.id,
      location_type_id: location_type.id,
      host_id: host.id,
      host_variety_id: host_variety.id,
      suspected_pathology_id: suspected_pathology.id,
      inserted_at: timestamp,
      updated_at: timestamp
    }
  end
end
|> List.flatten()

Repo.insert_all(Observation, observations)
