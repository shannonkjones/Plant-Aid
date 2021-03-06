import Config

# Only in tests, remove the complexity from the password hashing algorithm
case :os.type do
  {:win32, _} ->
    config :pbkdf2_elixir, :rounds, 1
  _ ->
    config :argon2_elixir, :rounds, 1
end

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :plant_aid, PlantAid.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "plant_aid_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :plant_aid, PlantAidWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "jWPnMSBShhfcZyu+tQjTtzv1AVjBwQIu/V+ZzprMJkv0OG123n0PczW4/iJmB2S9",
  server: false

# In test we don't send emails.
config :plant_aid, PlantAid.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
