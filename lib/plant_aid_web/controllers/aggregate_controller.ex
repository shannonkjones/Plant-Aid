defmodule PlantAidWeb.AggregateController do
  use PlantAidWeb, :controller

  alias PlantAid.Observations.AggregatesAgent

  def county_aggregates(conn, _params) do
    render(conn, "county_aggregates.json", counties: AggregatesAgent.get_aggregates())
  end
end
