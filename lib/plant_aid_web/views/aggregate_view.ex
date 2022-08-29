defmodule PlantAidWeb.AggregateView do
  use PlantAidWeb, :view

  def render("county_aggregates.json", %{counties: counties}) do
    %{
      type: "FeatureCollection",
      features: render_many(counties, PlantAidWeb.AggregateView, "feature.json")
    }
  end

  def render("feature.json", %{aggregate: county}) do
    %{
      type: "Feature",
      properties: %{
        name: county.name,
        state: county.state,
        observation_count: county.observation_count
      },
      geometry: county.geom
    }
  end
end
