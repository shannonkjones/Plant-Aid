### COPY FROM HERE ###
import Config

# Total expected observations = (4 + extra_users) * ((min_observations_per_user + max_observations_per_user) / 2), but this can vary widely
# By default this is 8 total users * 27.5 observations per user = 220
# If you'd like to change these values locally, copy this block to priv/repo/override_seed_config.exs (which is not in source control) and edit the values there
config :plant_aid,
  additional_users: 4,
  min_observations_per_user: 5,
  max_observations_per_user: 50
### TO HERE ###

# Import local overrides. This must remain at the bottom
# of this file so it overrides the configuration defined above.
try do
  import_config "override_seed_config.exs"
rescue
  File.Error -> nil
end
