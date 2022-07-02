alias PlantAid.Accounts.User
alias PlantAid.Repo

additional_users = Config.Reader.read!("priv/repo/seed_config.exs") |> Keyword.get(:plant_aid) |> Keyword.get(:additional_users)

password = User.hashing_library().hash_pwd_salt("password")
timestamp = DateTime.utc_now() |> DateTime.truncate(:second)
users = [
  %{email: "superuser@example.com", hashed_password: password, roles: [:superuser], inserted_at: timestamp, updated_at: timestamp},
  %{email: "admin@example.com", hashed_password: password, roles: [:admin], inserted_at: timestamp, updated_at: timestamp},
  %{email: "researcher@example.com", hashed_password: password, roles: [:researcher], inserted_at: timestamp, updated_at: timestamp},
] ++ for n <- 0..additional_users do
  %{email: "user#{n}@example.com", hashed_password: password, roles: [], inserted_at: timestamp, updated_at: timestamp}
end

Repo.insert_all(User, users)
