defmodule PlantAid.Repo do
  Postgrex.Types.define(
    PlantAid.PostgresTypes,
    [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
    json: Jason
  )

  use Ecto.Repo,
    otp_app: :plant_aid,
    adapter: Ecto.Adapters.Postgres
end
