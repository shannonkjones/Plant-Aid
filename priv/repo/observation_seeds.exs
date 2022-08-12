alias PlantAid.Accounts.User
alias PlantAid.Admin
alias PlantAid.Observations.Observation
alias PlantAid.Repo

config = Config.Reader.read!("priv/repo/seed_config.exs") |> Keyword.get(:plant_aid)
min_observations_per_user = Keyword.get(config, :min_observations_per_user)
max_observations_per_user = Keyword.get(config, :max_observations_per_user)

timestamp = DateTime.utc_now() |> DateTime.truncate(:second)
start_unix_timestamp = DateTime.new!(~D[2015-01-01], ~T[00:00:00]) |> DateTime.to_unix()
end_unix_timestamp = DateTime.to_unix(timestamp)
users = Repo.all(User)
location_types = Admin.list_location_types()
hosts = Admin.list_hosts()
pathologies = Admin.list_pathologies()

# hosts_to_pathologies = %{
#     "Tanoak" => ["Sudden Oak Death"],
#     "Bay Laurel" => ["Sudden Oak Death"],
#     "Tomato" => ["Late Blight", "Tomato Spotted Wilt Virus"],
#     "Potato" => ["Late Blight"],
#     "Rhododendron" => ["Sudden Oak Death"],
#     "Other" => ["Sudden Oak Death", "Late Blight", "Tomato Spotted Wilt Virus"],
# }
hosts_to_pathologies = %{
  "Tomato" => ["Late Blight"]
}

words = [
  "ant", "bat", "cat", "dog", "eagle", "fox", "goat", "horse", "impala", "jaguar", "koala", "lion", "mouse", "narwhal", "octopus", "pig", "quail", "rat", "snake", "tiger", "umbrellabird", "vulture", "walrus", "xerus", "yak", "zebra"
]

observations = for u <- users do
  num_observations = Enum.random(min_observations_per_user..max_observations_per_user)
  for _ <- 1..num_observations do
    observation_date = Enum.random(start_unix_timestamp..end_unix_timestamp) |> DateTime.from_unix!() |> DateTime.truncate(:second)
    location_type = Enum.random(location_types)
    host = Enum.random(hosts)
    control_method = Enum.take_random(words, 3) |> Enum.join(" ")
    notes = Enum.take_random(words, 20) |> Enum.join(" ")
    suspected_pathology_name = Map.get(hosts_to_pathologies, host.common_name) |> Enum.random()
    suspected_pathology = Enum.find(pathologies, fn p -> p.common_name == suspected_pathology_name end)
    longitude = :rand.uniform() * 4 - 80.947
    latitude = :rand.uniform() * 2 + 34.914
    coordinates = %Geo.Point{coordinates: {longitude, latitude}, srid: 4326}
    organic = :rand.uniform() >= 0.5

    observation = %{
      status: :unsubmitted,
      observation_date: observation_date,
      coordinates: coordinates,
      organic: organic,
      user_id: u.id,
      host_id: host.id,
      location_type_id: location_type.id,
      suspected_pathology_id: suspected_pathology.id,
      control_method: control_method,
      notes: notes,
      inserted_at: timestamp,
      updated_at: timestamp
    }

    if host.common_name == "Other" do
      Map.put(observation, :host_other, Enum.random(words))
    else
      if length(host.varieties) > 0 do
        Map.put(observation, :host_variety_id, Enum.random(host.varieties).id)
      else
        observation
      end
    end
  end
end
|> List.flatten()

for observations_chunk <- Enum.chunk_every(observations, 2500) do
  Repo.insert_all(Observation, observations_chunk)
end
