defmodule PlantAid.Observations.AggregatesAgent do
  use Agent

  alias PlantAid.Observations

  def start_link(_) do
    aggregates = Observations.get_county_aggregates()
    Agent.start_link(fn -> aggregates end, name: __MODULE__)
  end

  def get_aggregates() do
    Agent.get(__MODULE__, fn state -> state end)
  end
end
